# frozen_string_literal: true

module Cab
  need 'helpers/log'

  module Tasks
    class Transfer
      # Модуль, предназначенный для подключения к содержащему классу
      module Helpers
        include Cab::Helpers::Log

        # Создаёт запись в журнале событий о том, что импортирована запись
        # физического лица
        # @param [Hash] ecm_person
        #   ассоциативный массив полей исходной записи физического лица
        # @param [Array] result
        #   список проблем, возникших при импорте
        def log_import_individual(ecm_person, result)
          log_info { <<-MESSAGE } if result.empty?
            Импортирована запись физического лица с идентификатором записи
            #{ecm_person[:id]}
          MESSAGE
        end

        # Создаёт запись в журнале событий о том, что импортирована запись
        # индивидуального предпринимателя или юридического лица
        # @param [Hash] ecm_person
        #   ассоциативный массив полей исходной записи
        # @param [Hash] ecm_organization
        #   ассоциативный массив полей исходной записи организации
        # @param [Array] result
        #   список проблем, возникших при импорте
        def log_import_organization(ecm_person, ecm_org, result)
          log_info { ecm_org[:type] == 'B' ? <<-ENT : <<-ORG } if result.empty?
            Импортирована запись индивидуального предпринимателя с
            идентификатором записи #{ecm_person[:id]}
          ENT
            Импортирована запись юридического лица с идентификатором записи
            #{ecm_person[:id]}
          ORG
        end

        # Создаёт запись в журнале событий о том, что импортирована запись
        # связи между заявителем и представителем
        # @param [String] person_id
        #   идентификатор записи заявителя
        # @param [String] agent_id
        #   идентификатор записи представителя
        # @param [String] doc_id
        #   идентификатор записи документа
        # @param [Array] result
        #   список проблем, возникших при импорте
        def log_import_vicarious_authority(person_id, agent_id, doc_id, result)
          log_info { <<-MESSAGE } if result.empty?
            Импортирована запись связи между записями заявителя, представителя
            и документа, подтверждающего полномочия представителя, с
            идентификаторами `#{person_id}`, `#{agent_id}`, `#{doc_id}`
          MESSAGE
        end

        # Создаёт запись в журнале событий об окончании импорта
        # @param [Hash] stats
        #   ассоциативный массив, в котором идентификаторам исходных записей
        #   заявителей сопоставлены списки проблем, произошедших при импорте
        #   этих записей
        # @param [String] filepath
        #   путь до файла с результатами импорта записей
        # @param [String] va_filepath
        #   путь до файла с результатами импорта записей
        def log_finish(stats, filepath, va_filepath)
          imported, failed = stats.each_with_object([0, 0]) do |(_, err), memo|
            err.empty? ? memo[0] += 1 : memo[1] += 1
          end
          log_info { "Импортированы записи в количестве #{imported}" }
          log_info { "Не удалось импортировать записи в количестве #{failed}" }
          log_csv(filepath)
          log_va_csv(va_filepath)
        end

        # Создаёт запись в журнале событий о том, где находится информация об
        # импорте записей
        # @param [String] filepath
        #   путь до файла с результатами импорта записей
        def log_csv(filepath)
          log_info { <<-MESSAGE }
            Информация об импорте записей находится в CSV-файле по пути
            `#{filepath}`
          MESSAGE
        end

        # Создаёт запись в журнале событий о том, где находится информация об
        # импорте связей между заявителями и представителями
        # @param [String] filepath
        #   путь до файла с результатами импорта записей связей
        def log_va_csv(filepath)
          log_info { <<-MESSAGE }
            Информация об импорте связей между заявителями и представителями
            находится в CSV-файле по пути `#{filepath}`
          MESSAGE
        end
      end
    end
  end
end
