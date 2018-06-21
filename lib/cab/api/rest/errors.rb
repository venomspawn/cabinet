# frozen_string_literal: true

require 'json-schema'

module Cab
  need 'helpers/log'

  module API
    module REST
      # Модуль описаний обработчиков ошибок
      module Errors
        # Модуль вспомогательных методов
        module Helpers
          include Cab::Helpers::Log

          # Возвращает объект, связанный с ошибкой
          # @return [Exception]
          #   объект-исключение
          def error
            env['sinatra.error']
          end

          # Возвращает название сервиса в верхнем регистре без знаков
          # подчёркивания и дефисов. Необходимо для журнала событий.
          # @return [String]
          #   преобразованное название сервиса
          def app_name_upcase
            Cab.name.upcase
          end

          # Создаёт запись в журнале сообщений о классе и сообщении ошибки
          def log_regular_error
            log_error { <<~LOG }
              #{app_name_upcase} ERROR #{error.class} WITH MESSAGE
              #{error.message}
            LOG
          end

          # Создаёт запись в журнале сообщений о классе и сообщении ошибки, а
          # также о стеке вызовов
          def log_500_error
            log_error { <<~LOG }
              #{app_name_upcase} ERROR #{error.class} WITH MESSAGE
              #{error.message} AT #{error.backtrace.first(3)}
            LOG
          end
        end

        # Отображение классов ошибок в коды ошибок
        ERRORS_MAP = {
          ArgumentError                     => 422,
          JSON::Schema::ValidationError     => 422,
          Oj::ParseError                    => 422,
          RuntimeError                      => 422,
          Sequel::DatabaseError             => 422,
          Sequel::Error                     => 422,
          Sequel::NoMatchingRow             => 404,
          Sequel::InvalidValue              => 422,
          Sequel::UniqueConstraintViolation => 422
        }.freeze

        # Регистрирует обработчик ошибки
        # @param [CaseCore::API::REST::Controller] controller
        #   контроллер
        # @param [Class] error_class
        #   класс ошибки
        # @param [Integer] error_code
        #   код ошибки
        def self.define_error_handler(controller, error_class, error_code)
          controller.error error_class do
            log_regular_error
            status error_code
            content = { error: error_class, message: error.message }
            body Oj.dump(content)
          end
        end

        # Регистрирует обработчики ошибок, классы которых определены в
        # {ERRORS_MAP}
        # @param [CaseCore::API::REST::Controller] controller
        #   контроллер
        def self.define_error_handlers(controller)
          ERRORS_MAP.each do |error_class, error_code|
            define_error_handler(controller, error_class, error_code)
          end
        end

        # Регистрирует обработчик ошибок, классы которых не определены в
        # {ERRORS_MAP}
        # @param [CaseCore::API::REST::Controller] controller
        #   контроллер
        def self.define_500_handler(controller)
          controller.error 500 do
            log_500_error
            status 500
            content = { error: error.class, message: error.message }
            body Oj.dump(content)
          end
        end

        # Регистрация в контроллере обработчиков ошибок
        # @param [CaseCore::API::REST::Controller] controller
        #   контроллер
        def self.registered(controller)
          controller.helpers Helpers
          define_error_handlers(controller)
          define_500_handler(controller)
        end
      end

      Controller.register Errors
    end
  end
end
