# frozen_string_literal: true

module Cab
  module Tasks
    class Transfer
      class Cabinet
        # Класс, предоставляющий функцию для извлечения информации о
        # документах заявителей
        class ECMDocuments
          # Возвращает ассоциативный массив, в котором идентификаторам папок
          # заявителей сопоставлены списки ассоциативных массивов с
          # информацией о документах заявителей
          # @param [Sequel::Database] db
          #   объект, предоставляющий доступ к базе данных `cabinet`
          # @return [Hash]
          #   результирующий ассоциативный массив
          def self.data(db)
            new(db).data
          end

          # Инициализирует объект класса
          # @param [Sequel::Database] db
          #   объект, предоставляющий доступ к базе данных `cabinet`
          def initialize(db)
            @db = db
          end

          # Возвращает ассоциативный массив, в котором идентификаторам папок
          # заявителей сопоставлены списки ассоциативных массивов с
          # информацией о документах заявителей
          # @return [Hash]
          #   результирующий ассоциативный массив
          def data
            dataset.each_with_object({}) do |document, memo|
              document[:content] = unpack_content(document)
              document[:attachment] = unpack_attachment(document)
              folder_id = document[:folder_id]
              memo[folder_id] ||= []
              memo[folder_id] << document
            end
          end

          private

          # Объект, предоставляющий доступ к базе данных `cabinet`
          # @return [Sequel::Database]
          #   объект, предоставляющий доступ к базе данных `cabinet`
          attr_reader :db

          # Список названий столбцов, извлекаемых из таблицы `ecm_documents`
          ECM_DOCUMENTS_COLUMNS =
            %i[id attachments content created_at folder_id schema_urn].freeze

          # Возвращает запрос Sequel на получение записей документов
          # @return [Sequel::Dataset]
          #   результирующий запрос Sequel
          def dataset
            db[:ecm_documents]
              .where(folder_id: folder_ids_dataset)
              .select(*ECM_DOCUMENTS_COLUMNS)
          end

          # Возвращает запрос Sequel на получение набора идентификаторов
          # папок заявителей
          # @return [Sequel::Dataset]
          #   результирующий запрос Sequel
          def folder_ids_dataset
            db[:ecm_people].select(:private_folder_id)
          end

          # Возвращает ассоциативный массив, восстановлённый из содержимого
          # документа в ECM-формате
          # @param [Hash] document
          #   ассоциативный массив с информацией о документе
          # @return [Hash]
          #   результирующий ассоциативный массив
          def unpack_content(document)
            content = document[:content]
            content = Oj.load(content)
            content = [content] if content.is_a?(Hash)
            unpack(content).each_value.first
          rescue StandardError
            {}
          end

          # Возвращает объект, восстанавливая его из ECM-формата
          # @param [Object] content
          #   исходный объект
          # @return [Object]
          #   объект, восстановлённый из ECM-формата
          def unpack(content)
            return content unless content.is_a?(Array)
            content.each_with_object({}) do |e, memo|
              return content unless e.is_a?(Hash) && e.key?(:content)
              name = e[:name]
              return content unless name.is_a?(String)
              memo[name.to_sym] = unpack(e[:content])
            end
          end

          # Возвращает идентификатор файла в файловом хранилище, прикреплённого
          # к документу, или `nil`, если идентификатор файла невозможно
          # восстановить
          # @param [Hash] document
          #   ассоциативный массив с информацией о документе
          # @return [String]
          #   идентификатор файла в файловом хранилище
          # @return [NilClass]
          #   если идентификатор файла невозможно восстановить
          def unpack_attachment(document)
            attachments = document.delete(:attachments)
            Oj.load(attachments).first.last[:storage_key]
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
