# frozen_string_literal: true

require 'csv'
require 'set'

require_relative 'transfer/cabinet'
require_relative 'transfer/helpers'
require_relative 'transfer/importers/entrepreneur'
require_relative 'transfer/importers/individual'
require_relative 'transfer/importers/organization'

module Cab
  module Tasks
    # Класс объектов, запускающих перенос данных заявителей из старого сервиса
    class Transfer
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
      end

      # Путь до директории со временными файлами
      TMP_DIRPATH = "#{Cab.root}/tmp"

      # Путь до CSV-файла с информацией о неудачном импорте записей
      FAILURES_INFO_FILEPATH =
        "#{TMP_DIRPATH}/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.csv"

      # Запускает перенос данных заявителей из старого сервиса
      def launch!
        import_individuals
        import_organizations
        save_results
        log_finish(stats, FAILURES_INFO_FILEPATH)
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

      # Возвращает тип импортированной записи
      # @param [Hash] ecm_person
      #   ассоциативный массив полей исходной записи заявителя
      def ecm_person_type(ecm_person)
        ecm_org_id = ecm_person[:organization_id]
        return 'ФЛ' if ecm_org_id.nil?
        ecm_org = cabinet.ecm_organizations[ecm_org_id]
        ecm_org[:type] == 'B' ? 'ИП' : 'ЮЛ'
      end

      # Создаёт директорию {TMP_DIRPATH}
      def make_temp_dir
        `mkdir -p #{TMP_DIRPATH}`
      end

      # Заголовки CSV-файла с информацией о неудачном импорте записей
      FAILURES_INFO_HEADERS = [
        'Идентификатор',
        'Тип',
        'Дата и время создания',
        'Причины неудачи'
      ].freeze

      # Открывает CSV-файл для блока и добавляет в него заголовки
      # @yieldparam [CSV] csv
      #   CSV-файл
      def open_csv
        CSV.open(FAILURES_INFO_FILEPATH, 'wb') do |csv|
          csv << FAILURES_INFO_HEADERS
          yield csv
        end
      end

      # Сохраняет результаты импорта в CSV-файл
      def save_results
        make_temp_dir
        open_csv do |csv|
          stats.each do |id, err|
            next if err.empty?
            ecm_person = cabinet.ecm_people[id]
            err = err.join(', ')
            created_at = ecm_person[:created_at].strftime('%d.%m.%Y %T')
            csv << [id, ecm_person_type(ecm_person), created_at, err]
          end
        end
      end
    end
  end
end
