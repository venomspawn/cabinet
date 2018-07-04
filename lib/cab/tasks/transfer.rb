# frozen_string_literal: true

require 'set'

require_relative 'transfer/cabinet'
require_relative 'transfer/csv'
require_relative 'transfer/helpers'
require_relative 'transfer/importers/entrepreneur'
require_relative 'transfer/importers/individual'
require_relative 'transfer/importers/organization'
require_relative 'transfer/importers/vicarious_authority'

module Cab
  module Tasks
    # Класс объектов, запускающих перенос данных заявителей из старого сервиса
    class Transfer
      include CSV
      include Helpers

      # Создаёт экземпляр клааса и запускает перенос данных заявителей из
      # старого сервиса
      def self.launch!
        new.launch!
      end

      # Инициализирует объект класса
      def initialize
        @cabinet = Cabinet.new
        @individual_ids = extract_individual_ids
        @organization_ids = extract_organization_ids
        @stats = {}
        @va_stats = {}
      end

      # Запускает перенос данных заявителей из старого сервиса
      def launch!
        import_individuals
        import_organizations
        import_vicarious_authorities
        make_temp_dir
        save_stats_results(stats)
        save_va_stats_results(va_stats)
        log_finish(stats, FAILURES_INFO_FILEPATH, VA_FAILURES_INFO_FILEPATH)
      end

      private

      # Объект доступа к данным исходной базы данных
      # @return [Cab::Tasks::Transfer::Cabinet]
      #   объект доступа к данным исходной базы данных
      attr_reader :cabinet

      # Множество идентификаторов имеющихся записей физических лиц
      # @return [Set]
      #   множество идентификаторов имеющихся записей физических лиц
      attr_reader :individual_ids

      # Множество идентификаторов имеющихся записей индивидуальных
      # предпринимателей и юридических лиц
      # @return [Set]
      #   множество идентификаторов имеющихся записей индивидуальных
      #   предпринимателей и юридических лиц
      attr_reader :organization_ids

      # Ассоциативный массив, в котором идентификаторам исходных записей
      # заявителей сопоставлены списки проблем, произошедших при импорте этих
      # записей
      # @return [Hash]
      #   ассоциативный массив, в котором идентификаторам исходных записей
      #   заявителей сопоставлены списки проблем, произошедших при импорте этих
      #   записей
      attr_reader :stats

      # Ассоциативный массив, в котором спискам из идентификаторов записей
      # заявителей и идентификаторов записей представителей сопоставлены списки
      # проблем, произошедших при импорте информации о доверенностях
      # @return [Hash]
      #   ассоциативный массив, в котором спискам из идентификаторов записей
      #   заявителей, представителей и документов, удостоверяющих полномочия
      #   представителей, сопоставлены списки проблем, произошедших при импорте
      #   информации о доверенностях
      attr_reader :va_stats

      # Возвращает множество идентификаторов имеющихся записей физических лиц
      # @return [Set]
      #   множество идентификаторов имеющихся записей физических лиц
      def extract_individual_ids
        Sequel::Model.db[:individuals].select_map(:id).to_set
      end

      # Возвращает множество идентификаторов имеющихся записей индивидуальных
      # предпринимателей и юридических лиц
      # @return [Set]
      #   множество идентификаторов имеющихся записей индивидуальных
      #   предпринимателей и юридических лиц
      def extract_organization_ids
        entrepreneur_ids = Sequel::Model.db[:entrepreneurs].select_map(:id)
        organization_ids = Sequel::Model.db[:organizations].select_map(:id)
        entrepreneur_ids.concat(organization_ids).to_set
      end

      # Импортирует записи физических лиц
      def import_individuals
        cabinet.ecm_people.each(&method(:import_individual))
      end

      # Импортирует запись физического лица
      # @param [String] ecm_person_id
      #   идентификатор записи
      # @param [Hash] ecm_person
      #   ассоциативный массив с полями записи
      def import_individual(ecm_person_id, ecm_person)
        return if ecm_person[:organization_id].present?
        return if individual_ids.include?(ecm_person_id)
        result = Importers::Individual.new(ecm_person, cabinet).import
        stats[ecm_person_id] = result
        log_import_individual(ecm_person, result)
      end

      # Импортирует записи индивидуальных предпринимателей и юридических лиц
      def import_organizations
        cabinet.ecm_people.each(&method(:import_organization))
      end

      # Ассоциативный массив, в котором типам исходных записей организаций
      # сопоставляются класса объектов, импортирующих эти записи
      IMPORTER_CLASSES = {
        'B' => Importers::Entrepreneur,
        'L' => Importers::Organization
      }.freeze

      # Импортирует запись индивидуального предпринимателя или юридического
      # лица
      # @param [String] ecm_person_id
      #   идентификатор записи
      # @param [Hash] ecm_person
      #   ассоциативный массив с полями записи
      def import_organization(ecm_person_id, ecm_person)
        return if organization_ids.include?(ecm_person_id)
        ecm_org_id = ecm_person[:organization_id] || return
        ecm_org = cabinet.ecm_organizations[ecm_org_id] || return
        importer_class = IMPORTER_CLASSES[ecm_org[:type]] || return
        result = importer_class.new(ecm_person, ecm_org, cabinet).import
        stats[ecm_person_id] = result
        log_import_organization(ecm_person, ecm_org, result)
      end

      # Импортирует записи связей между заявителями и их представителями
      def import_vicarious_authorities
        cabinet
          .vicarious_authorities
          .each(&method(:import_vicarious_authority))
      end

      # Импортирует информацию о доверенности
      # @param [String] person_id
      #   идентификатор записи заявителя
      # @param [String] agent_id
      #   идентификатор записи представителя
      # @param [Array<Hash>] doc
      #   информация о доверенностях
      def import_vicarious_authority((person_id, agent_id), docs)
        docs.each do |doc|
          result =
            Importers::VicariousAuthority.new(person_id, agent_id, doc).import
          va_stats[[person_id, agent_id, doc[:id], doc[:created_at]]] = result
          log_import_vicarious_authority(person_id, agent_id, doc[:id], result)
        end
      end

      # Возвращает тип импортированной записи
      # @param [Hash] ecm_person
      #   ассоциативный массив полей исходной записи заявителя
      def ecm_person_type(ecm_person)
        ecm_org_id = ecm_person[:organization_id]
        return 'ФЛ' if ecm_org_id.nil?
        ecm_org = cabinet.ecm_organizations[ecm_org_id]
        ecm_org[:type] == 'B' ? 'ИП' : 'ЮЛ'
      end
    end
  end
end
