# frozen_string_literal: true

module Cab
  module Tasks
    class Transfer
      # Класс объектов, предоставляющих возможность работы с базой данных
      # старого сервиса личного кабинета заявителей
      class Cabinet
        require_relative 'cabinet/ecm_documents'
        require_relative 'cabinet/vicarious_authorities'

        # Ассоциативный массив, в котором идентификаторам записей заявителей
        # сопоставлены ассоциативные массивы с информацией о заявителях
        # @return [Hash]
        #   ассоциативный массив с информацией о заявителях
        attr_reader :ecm_people

        # Ассоциативный массив, в котором идентификаторам записей организаций
        # сопоставлены ассоциативные массивы с информацией об организациях
        # @return [Hash]
        #   ассоциативный массив с информацией об организациях
        attr_reader :ecm_organizations

        # Ассоциативный массив, в котором идентификаторам папок заявителей
        # сопоставлены списки ассоциативных массивов с информацией о
        # документах
        # @return [Hash]
        #   ассоциативный массив с информацией о документах
        attr_reader :ecm_documents

        # Ассоциативный массив, в котором идентификаторам записей заявителей
        # сопоставлены ассоциативные массивы с информацией об адресах их
        # регистрации
        # @return [Hash]
        #   ассоциативный массив с информацией об адресах регистрации
        attr_reader :ecm_addresses

        # Ассоциативный массив, в котором идентификаторам записей заявителей
        # сопоставлены ассоциативные массивы с информацией об их фактических
        # адресах
        # @return [Hash]
        #   ассоциативный массив с информацией о фактических адресах
        attr_reader :ecm_factual_addresses

        # Ассоциативный массив, в котором спискам из идентификаторов записей
        # заявителя и представителя соответствует ассоциативный массив с
        # информацией о последней доверенности
        # @return [Hash]
        #   ассоциативный массив с информацией о доверенностях
        attr_reader :vicarious_authorities

        # Инициализирует объект класса
        def initialize
          params = {
            adapter:  'mysql2',
            host:     ENV['OLDCAB_DB_HOST'],
            database: ENV['OLDCAB_DB_NAME'],
            user:     ENV['OLDCAB_DB_USER'],
            password: ENV['OLDCAB_DB_PASS']
          }
          @db = Sequel.connect(params)
          initialize_collections
        end

        private

        # Объект, предоставляющий доступ к базе данных
        # @return [Sequel::Database]
        #   объект, предоставляющий доступ к базе данных
        attr_reader :db

        # Инициализирует коллекции данных
        def initialize_collections
          initialize_ecm_people
          initialize_ecm_organizations
          initialize_ecm_documents
          initialize_ecm_addresses
          initialize_ecm_factual_addresses
          initialize_vicarious_authorities
        end

        # Список названий столбцов, извлекаемых из таблицы `ecm_people`
        ECM_PEOPLE_COLUMNS = %i[
          id
          name
          last_name
          first_name
          middle_name
          birth_date
          birth_place
          sex
          foreigner
          inn
          ogrn
          snils
          organization_id
          private_folder_id
          created_at
        ].freeze

        # Инициализирует коллекцию данных о заявителях
        def initialize_ecm_people
          @ecm_people =
            db[:ecm_people].select(*ECM_PEOPLE_COLUMNS).as_hash(:id)
        end

        # Инициализирует коллекцию данных о заявителях
        def initialize_ecm_organizations
          @ecm_organizations = db[:ecm_organizations].as_hash(:id)
        end

        # Инициализирует коллекцию данных о документах
        def initialize_ecm_documents
          @ecm_documents = ECMDocuments.data(db)
        end

        # Инициализирует коллекцию данных об адресах регистрации
        def initialize_ecm_addresses
          @ecm_addresses = db[:ecm_addresses].as_hash(:person_id)
        end

        # Инициализирует коллекцию данных о фактических адресах
        def initialize_ecm_factual_addresses
          data = db[:ecm_factual_addresses]
          @ecm_factual_addresses = data.as_hash(:person_id)
        end

        # Инициализирует коллекцию данных о доверенностях
        def initialize_vicarious_authorities
          @vicarious_authorities =
            VicariousAuthorities.data(db, ecm_people, ecm_documents)
        end
      end
    end
  end
end
