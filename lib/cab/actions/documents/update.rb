# frozen_string_literal: true

module Cab
  need 'actions/base/record_action'

  module Actions
    module Documents
      # Класс действий обновления содержимого файла документа, удостоверяющего
      # личность
      class Update < Base::RecordAction
        require_relative 'update/params_schema'

        # Обновляет содержимое файла документа, удостоверяющего личность
        def update
          record.update(content: content)
        end

        private

        # Возвращает запись документа, удостоверяющего личность
        # @return [Cab::Models::IdentityDocument]
        #   запись документа, удостоверяющего личность
        # @raise [Sequel::NoMatchingRow]
        #   если запись документа, удостоверяющего личность, не найдена
        def record
          Models::IdentityDocument.select(:id).with_pk!(id)
        end

        # Возвращает новое содержимое документа, удостоверяющего личность
        # @return [String]
        #   новое содержимое документа, удостоверяющего личность
        def content
          params[:content]
        end
      end
    end
  end
end
