# frozen_string_literal: true

require 'csv'
require 'rest-client'
require 'json'

# EIRReportInterface is a module that provides reporting services
# related to the EIR (Electronic Immunization Registry).
module EIRReportInterface
  # EIRReportInterfaceService is a module within EIRReportInterface
  # that provides various service methods for reporting and data disaggregation.
  module EIRReportInterfaceService
    class << self
      # Reads and parses settings from a JSON file.
      # @return [Hash] Parsed JSON configuration
      def settings
        file = File.read(Rails.root.join('db', 'idsr_metadata', 'idsr_ohsp_settings.json'))
        JSON.parse(file)
      end

      # Reads and parses server configuration from a YAML file.
      # @return [Hash] Parsed YAML configuration
      def server_config
        YAML.load_file("#{Rails.root}/config/application.yml")
      end

      # Disaggregates data based on the provided criteria.
      # @param disaggregate_key [String] The key for disaggregation (e.g., 'less', 'greater')
      # @param concept_ids [Array<Integer>] The concept IDs to filter by
      # @param start_date [Date] The start date for the date range
      # @param end_date [Date] The end date for the date range
      # @param type [EncounterType] The encounter type
      # @return [Hash] A hash containing the disaggregated data
      def disaggregate(disaggregate_key, concept_ids, start_date, end_date, type)
        data = fetch_data(concept_ids, start_date, end_date, type)
        { 'ids' => filter_data(data, disaggregate_key) }
      end

      # Fetches data from the database based on the provided criteria.
      # @param concept_ids [Array<Integer>] The concept IDs to filter by
      # @param start_date [Date] The start date for the date range
      # @param end_date [Date] The end date for the date range
      # @param type [EncounterType] The encounter type
      # @return [ActiveRecord::Relation] The fetched data
      def fetch_data(concept_ids, start_date, end_date, type)
        Encounter.where(
          'encounter_datetime BETWEEN ? AND ? AND encounter_type = ? AND value_coded IN (?) AND concept_id IN (6543, 6542)',
          start_date.to_date.strftime('%Y-%m-%d 00:00:00'),
          end_date.to_date.strftime('%Y-%m-%d 23:59:59'), type.id, concept_ids
        ).joins(
          'INNER JOIN obs ON obs.encounter_id = encounter.encounter_id
           INNER JOIN person p ON p.person_id = encounter.patient_id'
        ).select('encounter.encounter_type, obs.value_coded, p.*')
      end

      # Filters data based on the disaggregate key.
      # @param data [ActiveRecord::Relation] The data to filter
      # @param disaggregate_key [String] The key for disaggregation (e.g., 'less', 'greater')
      # @return [Array<Integer>] The filtered IDs
      def filter_data(data, disaggregate_key)
        filtered_data = case disaggregate_key
                        when 'less'
                          data.select { |record| calculate_age(record['birthdate']) < 5 }
                        when 'greater'
                          data.select { |record| calculate_age(record['birthdate']) >= 5 }
                        else
                          []
                        end
        filtered_data.collect { |record| record['person_id'] }
      end

      # Generates a hash of months with their respective date ranges.
      # @return [Array<Array<String>>] An array of month-date range pairs
      def months_generator
        months = {}
        count = 1
        curr_date = Date.today

        while count < 13
          curr_date -= 1.month
          months[curr_date.strftime('%Y%m')] = [
            curr_date.strftime('%B-%Y'),
            "#{curr_date.beginning_of_month} to #{curr_date.end_of_month}"
          ]
          count += 1
        end

        months.to_a
      end

      # Generates a hash of weeks with their respective date ranges.
      # @return [Array<Array<String>>] An array of week-date range pairs
      def weeks_generator
        weeks = {}
        first_day = (Date.today - 11.months).at_beginning_of_month
        add_initial_week(weeks, first_day)

        first_monday = first_day.next_week(:monday)

        while first_monday <= Date.today
          add_week(weeks, first_monday)
          first_monday += 7
        end

        this_wk = "#{Date.today.year}W#{Date.today.cweek}"
        weeks.reject { |key, _| key == this_wk }.to_a
      end

      # Adds the initial week to the weeks hash.
      # @param weeks [Hash] The hash to add the week to
      # @param first_day [Date] The first day of the initial week
      def add_initial_week(weeks, first_day)
        wk_of_first_day = first_day.cweek
        return unless wk_of_first_day > 1

        wk = "#{first_day.prev_year.year}W#{wk_of_first_day}"
        dates = "#{first_day - first_day.wday + 1} to #{first_day - first_day.wday + 1 + 6}"
        weeks[wk] = dates
      end

      # Adds a week to the weeks hash.
      # @param weeks [Hash] The hash to add the week to
      # @param first_monday [Date] The first Monday of the week
      def add_week(weeks, first_monday)
        wk = "#{first_monday.year}W#{first_monday.cweek}"
        dates = "#{first_monday} to #{first_monday + 6}"
        weeks[wk] = dates
      end

      # Calculates the age based on the date of birth.
      # @param dob [Date] The date of birth
      # @return [Integer] The calculated age
      def calculate_age(dob)
        ((Date.today - dob.to_date).to_i / 365).rescue(0)
      end
    end
  end
end
