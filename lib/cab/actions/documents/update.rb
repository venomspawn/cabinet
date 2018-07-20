# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Documents
      # Класс действий обновления содержимого файла документа, удостоверяющего
      # личность
      class Update < Base::Action
        require_relative 'update/params_schema'

        # Обновляет содержимое файла документа, удостоверяющего личность
        def update
          file.update(content: read_content)
        end

        private

        # Возвращает значение атрибута `id` ассоциативного массива параметров
        # @return [Object]
        #   результирующее значение
        def id
          params[:id]
        end

        # Возвращает новое содержимое документа, удостоверяющего личность
        # @return [String]
        #   новое содержимое документа, удостоверяющего личность
        def content
          params[:content]
        end

        # Возвращает запись документа, удостоверяющего личность
        # @return [Cab::Models::IdentityDocument]
        #   запись документа, удостоверяющего личность
        # @raise [Sequel::NoMatchingRow]
        #   если запись документа, удостоверяющего личность, не найдена
        def record
          Models::IdentityDocument.select(:file_id).with_pk!(id)
        end

        # Возвращает запись файла документа, удостоверяющего личность
        # @return [Cab::Models::File]
        #   запись файла документа, удостоверяющего личность
        # @raise [Sequel::NoMatchingRow]
        #   если запись документа, удостоверяющего личность, не найдена
        def file
          Models::File.select(:id).with_pk(record.file_id)
        end

        # Возвращает содержимое файла
        # @return [String]
        #   содержимое файла
        def read_content
          return content.to_s unless content.respond_to?(:read)
          content.rewind if content.respond_to?(:rewind)
          content.read.to_s
        end
      end
    end
  end
end
