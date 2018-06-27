# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий создания записей индивидуальных предпринимателей
      class Create < Base::Action
        require_relative 'create/params_schema'

        # Создаёт запись индивидуального предпринимателя и возвращает
        # ассоциативный массив с информацией о созданной записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          Sequel::Model.db.transaction(savepoint: true) do
            individual = process_individual
            record = create_entrepreneur(individual)
            vicarious_authority = create_vicarious_authority
            create_entrepreneur_spokesman(record, vicarious_authority)
            individual.update(id: record.id)
          end
        end

        private

        # Возвращает запись представителя или `nil`, если запись
        # индивидуального предпринимателя создаётся без указания записи
        # представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        # @return [NilClass]
        #   если запись индивидуального предпринимателя создаётся без указания
        #   записи представителя
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def spokesman
          return if params[:spokesman].nil?
          @spokesman ||=
            Models::Individual.select(:id).with_pk!(params[:spokesman][:id])
        end

        # Возвращает значение параметра `individual_id`
        # @return [Object]
        #   значение параметра `individual_id`
        def individual_id
          params[:individual_id]
        end

        # Извлекает и возвращает ассоциативный массив с информацией о
        # физическом лице с идентификатором записи, равным значению параметра
        # `individual_id`, если оно предоставлено. В противном случае создаёт
        # запись физического лица и возвращает ассоциативный массив с
        # информацией о физическом лице.
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def process_individual
          return Individuals.create(individual_params) if individual_id.nil?
          { id: Models::Individual.select(:id).with_pk!(individual_id).id }
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          first_name:            :first_name,
          last_name:             :last_name,
          middle_name:           :middle_name,
          birth_place:           :birth_place,
          birth_date:            :birth_date,
          sex:                   :sex,
          citizenship:           :citizenship,
          snils:                 :snils,
          inn:                   :inn,
          registration_address:  :registration_address,
          residential_address:   :registration_address,
          identity_document:     :identity_document,
          consent_to_processing: :consent_to_processing
        }.freeze

        # Возвращает ассоциативный массив параметров создания записи
        # физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS)
        end

        # Создаёт и возвращает запись индивидуального предпринимателя
        # @param [Hash] individual
        #   ассоциативный массив с информацией о физическом лице
        # @return [Cab::Models::Entrepreneur]
        #   созданная запись
        def create_entrepreneur(individual)
          record_params = entrepreneur_params(individual)
          create_unrestricted(:Entrepreneur, record_params)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи индивидуального предпринимателя в названия
        # ключей ассоциативного массива параметров
        ENTREPRENEUR_FIELDS = {
          id:              SecureRandom.method(:uuid),
          actual_address:  :actual_address,
          bank_details:    :bank_details,
          commercial_name: :commercial_name,
          ogrn:            :ogrn,
          created_at:      Time.method(:now)
        }

        # Возвращает ассоциативный массив параметров создания записи
        # индивидуального предпринимателя
        # @param [Hash] individual
        #   ассоциативный массив с информацией о физическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_params(individual)
          extract_params(ENTREPRENEUR_FIELDS).tap do |hash|
            hash[:individual_id] = individual[:id]
          end
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя, если запись физического лица создаётся с указанием его
        # записи. Возвращает `nil` в противном случае.
        # @return [Cab::Models::VicariousAuthority]
        #   запись документа, подтверждающего полномочия представителя
        # @return [NilClass]
        #   если запись физического лица создаётся без указания записи
        #   представителя
        def create_vicarious_authority
          return if spokesman.nil?
          create_unrestricted(:VicariousAuthority, vicarious_authority_params)
        end

        # Ассоциативный массив, в котором сопоставляются названия полей записи
        # документа, подтверждающего полномочия представителя, и способы
        # извлечения значений этих полей из параметров действия
        VICARIOUS_AUTHORITY_FIELDS = {
          id:              SecureRandom.method(:uuid),
          name:            %i[spokesman title],
          number:          %i[spokesman number],
          series:          %i[spokesman series],
          registry_number: %i[spokesman registry_number],
          issued_by:       %i[spokesman issued_by],
          issue_date:      %i[spokesman issue_date],
          expiration_date: %i[spokesman due_date],
          content:         %i[spokesman content],
          created_at:      Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи документа,
        # подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def vicarious_authority_params
          extract_params(VICARIOUS_AUTHORITY_FIELDS)
        end

        # Создаёт запись связи между записями индивидуального предпринимателя и
        # его представителя, если запись индивидуального предпринимателя
        # создаётся с указанием записи представителя
        # @param [Cab::Models::Entrepreneur] record
        #   запись индивидуального предпринимателя
        # @param [NilClass, Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя, или
        #   `nil`, если запись индивидуального предпринимателя создаётся без
        #   указания записи представителя
        def create_entrepreneur_spokesman(record, vicarious_authority)
          return if vicarious_authority.nil?
          link_params =
            entrepreneur_spokesman_params(record, vicarious_authority)
          create_unrestricted(:EntrepreneurSpokesman, link_params)
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # индивидуального предпринимателя и его представителя
        # @param [Cab::Models::Entrepreneur] record
        #   запись индивидуального предпринимателя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_spokesman_params(record, vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            entrepreneur_id:        record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end
      end
    end
  end
end
