# frozen_string_literal: true

require_relative 'document_files'

module Cab
  module Tasks
    class Transfer
      module Importers
        # Класс объектов, импортирующих записи связей между записями заявителей
        # и записями представителей вместе с записями документов,
        # подтверждающих полномочия представителей
        class VicariousAuthority
          include DocumentFiles

          # Инициализирует объект класса
          # @param [String] person_id
          #   идентификатор записи заявителя
          # @param [String] spokesman_id
          #   идентификатор записи представителя
          # @param [Hash] doc
          #   ассоциативный массив с информацией о последней доверенности
          def initialize(person_id, spokesman_id, doc)
            @person_id = person_id
            @spokesman_id = spokesman_id
            @doc = doc
          end

          # Импортирует запись связи между записью заявителя и записью
          # представителя вместе с записью документа, подтверждающего
          # полномочия представителя. Возвращает пустой список в случае
          # успешного импорта, а в противном случае возвращает список с
          # описанием проблем, возникших при импорте.
          # @return [Array]
          #   результирующий список
          def import
            link_model = find_link_model
            fields = load_vicarious_authority_fields
            result = check_import(link_model, fields)
            return result unless result.empty?
            Sequel::Model.db.transaction do
              vicarious_authority = import_vicarious_authority(fields)
              import_link(link_model, vicarious_authority)
            end
            []
          end

          private

          # Идентификатор записи заявителя
          # @return [String]
          #   идентификатор записи заявителя
          attr_reader :person_id

          # Идентификатор записи представителя
          # @return [String]
          #   идентификатор записи представителя
          attr_reader :spokesman_id

          # Ассоциативный массив с информацией о последней доверенности
          # @return [Hash] doc
          #   ассоциативный массив с информацией о последней доверенности
          attr_reader :doc

          # Ассоциативный массив, в котором моделям заявителей сопоставлены
          # модели связей
          LINK_MODELS = {
            Models::Individual   => Models::IndividualSpokesman,
            Models::Entrepreneur => Models::EntrepreneurSpokesman,
            Models::Organization => Models::OrganizationSpokesman
          }.freeze

          # Возвращает модель связи или `nil`, если модель невозможно
          # определить
          # @return [Class]
          #   модель связи
          # @return [NilClass]
          #   если модель связи невозможно определить
          def find_link_model
            LINK_MODELS.each do |person_model, link_model|
              next if person_model.select(:id).with_pk(person_id).nil?
              return link_model
            end
            nil
          end

          # Ассоциативный массив, сопоставляющий названиям полей импортируемой
          # записи документа пути для извлечения данных из структуры исходной
          # записи документа
          DOC_PATHS = {
            id:              %i[id],
            name:            %i[content title],
            number:          %i[content nom],
            series:          %i[content ser],
            registry_number: %i[content registry_number],
            issued_by:       %i[content kemvid],
            issue_date:      %i[content datavid],
            expiration_date: %i[content deys]
          }.freeze

          # Возвращает ассоциативный массив полей записи документа,
          # подтверждающего полномочия представителя
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_vicarious_authority_fields
            hash = {
              content:    file(doc[:attachment]),
              created_at: doc[:created_at].strftime('%FT%T')
            }
            hash.tap { DOC_PATHS.each { |key, p| hash[key] = doc.dig(*p) } }
          end

          # Ассоциативный массив, в котором названиям полей импортируемой
          # записи документа сопоставлены сообщения о том, что эти поля
          # не заполнены
          FIELD_MESSAGES = {
            name:       'не заполнено название документа',
            issued_by:  'не заполнено, кем выдан документ',
            issue_date: 'не заполнена дата выдачи документа',
            content:    'отсутствует файл документа'
          }.freeze

          # Сообщение о том, что запись заявителя не найдена
          LINK_MODEL_ABSENT = 'запись заявителя не найдена'

          # Сообщение о том, что запись заявителя не найдена
          SPOKESMAN_ABSENT = 'запись представителя не найдена'

          # Сообщение о том, что запись связи присутствует в базе данных
          LINK_PRESENT = 'запись связи уже присутствует в базе данных'

          # Возвращает, отсутствует ли запись представителя
          # @return [Boolean]
          #   отсутствует ли запись представителя
          def spokesman_absent?
            Models::Individual.select(:id).with_pk(spokesman_id).nil?
          end

          # Возвращает, присутствует ли запись связи
          # @param [Class] link_model
          #   модель записи связи
          # @return [Boolean]
          #   присутствует ли запись связи
          def link_present?(link_model)
            key = [person_id, spokesman_id, doc[:id]]
            link_model.select(:spokesman_id).with_pk(key).present?
          end

          # Возвращает список с информацией о незаполненных полях в документе,
          # подтверждающем полномочия представителя
          # @param [NilClass, Class] link_model
          #   модель записи связи или `nil`
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          # @return [Array]
          #   результирующий список
          def check_import(link_model, fields)
            [].tap do |result|
              FIELD_MESSAGES.each do |field, message|
                result << message if fields[field].nil?
              end
              result << LINK_MODEL_ABSENT if link_model.nil?
              result << LINK_PRESENT if link_model && link_present?(link_model)
              result << SPOKESMAN_ABSENT if spokesman_absent?
            end
          end

          # Создаёт запись документа, подтверждающего полномочия представителя,
          # и возвращает её
          # @param [Hash] fields
          #   ассоциативный массив полей записи импортируемого документа
          # @return [Cab::Models::VicariousAuthority]
          #   созданная запись
          def import_vicarious_authority(fields)
            model = Models::VicariousAuthority
            model.unrestrict_primary_key
            model.create(fields).tap { model.restrict_primary_key }
          end

          # Ассоциативный массив, сопоставляющий моделям связи названия полей с
          # идентификатором записи заявителя
          APPLICANT_ID_FIELD_NAMES = {
            Models::IndividualSpokesman   => :individual_id,
            Models::EntrepreneurSpokesman => :entrepreneur_id,
            Models::OrganizationSpokesman => :organization_id
          }.freeze

          # Создаёт запись связи между записями заявителя, представителя и
          # документа, подтверждающего полномочия представителя
          # @param [Class] link_model
          #   модель записи связи
          # @param [Cab::Models::VicariousAuthority] vicarious_authority
          #   запись документа, подтверждающего полномочия представителя
          def import_link(link_model, vicarious_authority)
            applicant_id_field_name = APPLICANT_ID_FIELD_NAMES[link_model]
            link_params = {
              applicant_id_field_name => person_id,
              spokesman_id:              spokesman_id,
              vicarious_authority_id:    vicarious_authority.id,
              created_at:                vicarious_authority.created_at
            }
            link_model.unrestrict_primary_key
            link_model.create(link_params)
            link_model.restrict_primary_key
          end
        end
      end
    end
  end
end
