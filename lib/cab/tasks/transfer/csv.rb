# frozen_string_literal: true

require 'csv'

module Cab
  module Tasks
    class Transfer
      # Вспомогательный модуль, предоставляющий методы сохранения CSV-файлов
      module CSV
        # Путь до директории со временными файлами
        TMP_DIRPATH = "#{Cab.root}/tmp"

        # Путь до CSV-файла с информацией об импорте записей
        FAILURES_INFO_FILEPATH =
          "#{TMP_DIRPATH}/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.csv"

        # Путь до CSV-файла с информацией об импорте записей связей между
        # записями заявителей и представителей
        VA_FAILURES_INFO_FILEPATH =
          "#{TMP_DIRPATH}/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.va.csv"

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
          ::CSV.open(path, 'wb') { |csv| yield csv << headers }
        end

        # Сообщение о том, что запись заявителя успешно импортирована
        STATUS_OK = 'запись успешно импортирована'

        # Сохраняет результаты импорта в CSV-файл
        # @param [Hash] stats
        #   ассоциативный массив, в котором идентификаторам исходных записей
        #   заявителей сопоставлены списки проблем, произошедших при импорте
        #   этих записей
        def save_stats_results(stats)
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

        # Сортирует список списков с информацией об импорте записей связей
        # между заявителями и представителями и возвращает его
        # @param [Array<Array>] rows
        #   исходный список
        # @return [Array<Array>]
        #   исходный список
        def sort_va_rows(rows)
          rows.sort! do |a, b|
            (a[0] <=> b[0]) * 100 + (a[1] <=> b[1]) * 10 + (a[3] <=> b[3])
          end
        end

        # Возвращает список списков с информацией об импорте записей связей
        # между заявителями и представителями
        # @param [Hash] stats
        #   ассоциативный массив, в котором спискам из идентификаторов записей
        #   заявителей, представителей и документов, удостоверяющих полномочия
        #   представителей, сопоставлены списки проблем, произошедших при i
        #   импорте информации о доверенностях
        # @return [Array<Array>]
        #   результирующий список списков
        def csv_va_rows(stats)
          rows = stats.each_with_object([]) do |(key, status), memo|
            status = status.empty? ? STATUS_OK : status.join(', ')
            memo << key.dup.push(status)
          end
          sort_va_rows(rows).each { |r| r[3] = r[3].strftime('%d.%m.%Y %T') }
        end

        # Сохраняет результаты импорта в CSV-файл
        # @param [Hash] stats
        #   ассоциативный массив, в котором спискам из идентификаторов записей
        #   заявителей, представителей и документов, удостоверяющих полномочия
        #   представителей, сопоставлены списки проблем, произошедших при i
        #   импорте информации о доверенностях
        def save_va_stats_results(stats)
          open_csv(VA_FAILURES_INFO_FILEPATH, VA_FAILURES_INFO_HEADERS) do |cs|
            csv_va_rows(stats).each(&cs.method(:<<))
          end
        end
      end
    end
  end
end
