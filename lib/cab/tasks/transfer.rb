# frozen_string_literal: true

require 'set'

require_relative 'transfer/cabinet'
require_relative 'transfer/importers/individual'

module Cab
  need 'helpers/log'

  module Tasks
    # Класс объектов, запускающих перенос данных заявителей из старого сервиса
    class Transfer
      include Helpers::Log

      # Создаёт экземпляр клааса и запускает перенос данных заявителей из
      # старого сервиса
      def self.launch!
        new.launch!
      end

      def initialize
        @cabinet = Cabinet.new
        @individual_ids = extract_individual_ids
        @stats = {}
      end

      def launch!
        import_individuals
      end

      private

      attr_reader :cabinet
      attr_reader :individual_ids
      attr_reader :stats

      def extract_individual_ids
        Sequel::Model.db[:individuals].select_map(:id).to_set
      end

      def import_individuals
        cabinet.ecm_people.each(&method(:import_individual))
      end

      def import_individual(ecm_person_id, ecm_person)
        return if ecm_person[:organization_id].present?
        return if individual_ids.include?(ecm_person_id)
        result = Importers::Individual.new(ecm_person, cabinet).import
        stats[ecm_person_id] = result if result.size.positive?
        log_import_individual(ecm_person, result)
      end

      def log_import_individual(ecm_person, result)
        if result.size.positive?
          log_warn { <<-MESSAGE }
            При импорте записи физического лица с идентификатором
            #{ecm_person[:id]} произошли следующие ошибки: #{result.join(', ')}
          MESSAGE
        else
          log_info { <<-MESSAGE }
            Импортирована запись физического лица с идентификатором
            #{ecm_person[:id]}
          MESSAGE
        end
      end
    end
  end
end
