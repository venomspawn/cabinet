# frozen_string_literal: true

require 'csv'
require 'set'

require_relative 'transfer/cabinet'
require_relative 'transfer/helpers'
require_relative 'transfer/importers/entrepreneur'
require_relative 'transfer/importers/individual'
require_relative 'transfer/importers/organization'
require_relative 'transfer/importers/vicarious_authority'

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
        @va_stats = {}
      end

      # Путь до директории со временными файлами
      TMP_DIRPATH = "#{Cab.root}/tmp"

      # Путь до CSV-файла с информацией об импорте записей
      FAILURES_INFO_FILEPATH =
        "#{TMP_DIRPATH}/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.csv"

      # Путь до CSV-файла с информацией об импорте записей связей между
      # записями заявителей и представителей
      VA_FAILURES_INFO_FILEPATH =
        "#{TMP_DIRPATH}/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.va.csv"

      # Запускает перенос данных заявителей из старого сервиса
      def launch!
        #import_individuals
        #import_organizations
        import_vicarious_authorities
        make_temp_dir
        save_stats_results
        save_va_stats_results
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
          va_stats[[person_id, agent_id, doc[:id]]] = result
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

      # Создаёт директорию {TMP_DIRPATH}
      def make_temp_dir
        `mkdir -p #{TMP_DIRPATH}`
      end

      # Заголовки CSV-файла с информацией об импорте записей
      FAILURES_INFO_HEADERS = [
        'Идентификатор',
        'Тип',
        'Дата и время создания',
        'Статус'
      ].freeze

      # Открывает CSV-файл для блока и добавляет в него заголовки
      # @yieldparam [CSV] csv
      #   CSV-файл
      def open_csv(path, headers)
        CSV.open(path, 'wb') { |csv| yield csv << headers }
      end

      # Сообщение о том, что запись заявителя успешно импортирована
      STATUS_OK = 'запись успешно импортирована'

      # Сохраняет результаты импорта в CSV-файл
      def save_stats_results
        open_csv(FAILURES_INFO_FILEPATH, FAILURES_INFO_HEADERS) do |csv|
          stats.each do |id, status|
            ecm_person = cabinet.ecm_people[id]
            status = status.empty? ? STATUS_OK : status.join(', ')
            created_at = ecm_person[:created_at].strftime('%d.%m.%Y %T')
            csv << [id, ecm_person_type(ecm_person), created_at, status]
          end
        end
      end

      # Заголовки CSV-файла с информацией об импорте записей связей между
      # заявителями и представителями
      VA_FAILURES_INFO_HEADERS = [
        'Идентификатор записи заявителя',
        'Идентификатор записи представителя',
        'Идентификатор записи документа',
        'Дата и время создания',
        'Статус'
      ].freeze

      # Возвращает список списков с информацией об импорте записей связей между
      # заявителями и представителями
      # @return [Array<Array>]
      #   результирующий список списков
      def csv_va_rows
        puts "va_stats = #{va_stats}"
        rows = va_stats.each_with_object([]) do |(ids, status), memo|
          created_at = cabinet.ecm_documents[ids.last][:created_at]
          status = status.empty? ? STATUS_OK : status.join(', ')
          memo << ids.dup.push(created_at, status)
        end
        rows.sort! do |a, b|
          (a[0] <=> b[0]) * 100 + (a[1] <=> b[1]) * 10 + (a[3] <=> b[3])
        end
        rows.each { |row| row[3] = row[3].strftime('%d.%m.%Y %T') }
      end

      # Сохраняет результаты импорта в CSV-файл
      def save_va_stats_results
        open_csv(VA_FAILURES_INFO_FILEPATH, VA_FAILURES_INFO_HEADERS) do |csv|
          csv_va_rows.each(&csv.method(:<<))
        end
      end
    end
  end
end
