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
            Импортирована запись физического лица с идентификатором
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
            идентификатором #{ecm_person[:id]}
          ENT
            Импортирована запись юридического лица с идентификатором
            #{ecm_person[:id]}
          ORG
        end

        # Создаёт запись в журнале событий об окончании импорта
        # @param [Hash] stats
        #   ассоциативный массив, в котором идентификаторам исходных записей
        #   заявителей сопоставлены списки проблем, произошедших при импорте
        #   этих записей
        # @param [String] filepath
        #   путь до файла с результатами импорта
        def log_finish(stats, filepath)
          imported, failed = stats.each_with_object([0, 0]) do |(_, err), memo|
            err.empty? ? memo[0] += 1 : memo[1] += 1
          end
          log_info { "Импортированы записи в количестве #{imported}" }
          log_info { "Не удалось импортировать записи в количестве #{failed}" }
          log_info { <<-MESSAGE }
            Информация о неудачном импорте записей находится в CSV-файле по
            пути `#{filepath}`
          MESSAGE
        end
      end
    end
  end
end
