# frozen_string_literal: true

module Cab
  module Tasks
    class Transfer
      module Importers
        class Individual
          # Модуль методов извлечения значений полей записи физического лица
          module Loaders
            # Названия полей, извлекаемых из ассоциативного массива полей
            # исходной записи физического лица
            SLICE_FIELDS = %i[id middle_name birth_place sex].freeze

            # Ассоциативный массив, сопоставляющий названиями полей
            # импортируемой записи физического лица названия методов,
            # извлекающих значения этих полей
            LOADERS = {
              birthday:             :load_birthday,
              citizenship:          :load_citizenship,
              snils:                :load_snils,
              inn:                  :load_inn,
              registration_address: :load_registration_address,
              residence_address:    :load_residence_address,
              agreement:            :load_agreement,
              created_at:           :load_created_at
            }.freeze

            # Возвращает ассоциативный массив полей импортируемой записи
            # физического лица
            # @return [Hash]
            #   результирующий ассоциативный массив
            def load_individual_fields
              ecm_person.slice(*SLICE_FIELDS).tap do |hash|
                hash[:name]    = ecm_person[:first_name]
                hash[:surname] = ecm_person[:last_name]
                LOADERS.each { |key, name| hash[key] = send(name) }
              end
            end

            # Возвращает строку с датой рождения или `nil`, если дата рождения
            # не указана
            # @return [String]
            #   строка с датой рождения
            # @return [NilClass]
            #   если дата рождения не указана
            def load_birthday
              ecm_person[:birth_date]&.strftime('%F')
            end

            # Возвращает строку с датой создания записи
            # @return [String]
            #   строка с датой рождения
            def load_created_at
              ecm_person[:created_at].strftime('%FT%T')
            end

            # Ассоциативный массив, сопоставляющий значениям поля `foreigner`
            # исходной записи физического лица значения поля `citizenship`
            # импортируемой записи
            CITIZENSHIP = {
              nil   => 'russian',
              true  => 'russian',
              false => 'foreign'
            }.freeze

            # Возвращает значение поля `foreigner` исходной записи физического
            # лица
            # @return [Object]
            #   результирующее значение
            def ecm_person_foreigner
              ecm_person[:foreigner]
            end

            # Возвращает значение поля `citizenship` импортируемой записи
            # физического лица
            # @return [String]
            #   результирующее значение
            def load_citizenship
              CITIZENSHIP[ecm_person[:foreigner]]
            end

            # Формат строки СНИЛС
            SNILS_FORMAT = /^[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}$/

            # Возвращает строку со СНИЛС в правильном формате или `nil`, если
            # такую строку невозможно извлечь
            # @return [String]
            #   строка со СНИЛС
            # @return [NilClass]
            #   если строку со СНИЛС невозможно извлечь
            def load_snils
              s = ecm_person[:snils] || ecm_person[:name] || return
              return s if SNILS_FORMAT.match?(s)
              s = "#{s[0..2]}-#{s[3..5]}-#{s[6..8]} #{s[9..10]}"
              s if SNILS_FORMAT.match?(s)
            end

            # Формат строки ИНН
            INN_FORMAT = /^[0-9]{12}$/

            # Возвращает строку с ИНН в правильном формате или `nil`, если
            # такую строку невозможно извлечь
            # @return [String]
            #   строка с ИНН
            # @return [NilClass]
            #   если строку с ИНН невозможно извлечь
            def load_inn
              inn = ecm_person[:inn]
              inn if INN_FORMAT.match?(inn)
            end

            # Возвращает идентификатор исходной записи физического лица
            # @return [String]
            #   идентификатор исходной записи физического лица
            def ecm_person_id
              ecm_person[:id]
            end

            # Возвращает JSON-строку с адресом регистрации физического лица или
            # `nil`, если адрес регистрации не указан
            # @return [String]
            #   результирующая JSON-строка
            # @return [NilClass]
            #   если адрес регистрации не указан
            def load_registration_address
              address = cabinet.ecm_addresses[ecm_person_id]
              address && Oj.dump(address)
            end

            # Возвращает JSON-строку с фактическим адресом проживания
            # физического лица или `nil`, если фактический адрес проживания не
            # указан
            # @return [String]
            #   результирующая JSON-строка
            # @return [NilClass]
            #   если фактический адрес проживания не указан
            def load_residence_address
              address = cabinet.ecm_factual_addresses[ecm_person_id]
              address && Oj.dump(address)
            end

            # URN согласия на обработку персональных данных
            AGREEMENT_URN =
              'urn:metastore:documents.gosuslugi.Dokumenty_lichnogo_'\
              'xraneniya.Soglasie_na_obrabotku_personalnyx_dannyx'

            # Возвращает содержимое файла с согласием на обработку персональных
            # данных или `nil`, если файл не удалось извлечь из файлового
            # хранилища
            # @return [String]
            #   содержимое файла с согласием на обработку персональных данных
            # @return [NilClass]
            #   если файл не удалось извлечь из файлового хранилища
            def load_agreement
              agreement = ecm_documents.find do |doc|
                doc[:schema_urn].start_with?(AGREEMENT_URN)
              end
              storage_key = agreement && agreement[:attachment]
              storage_key && file(storage_key)
            end
          end
        end
      end
    end
  end
end
