module ByStar
  class ParseError < StandardError
  end

  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      include ByStar::ByDirection
      include ByStar::ByYear
      include ByStar::ByMonth
      include ByStar::ByFortnight
      include ByStar::ByWeek
      include ByStar::ByWeekend
      include ByStar::ByDay
      include ByStar::ByQuarter

      attr_reader :by_star_start_field, :by_star_end_field

      def by_star_field(start_field = nil, end_field = nil)
        @by_star_start_field ||= start_field
        @by_star_end_field   ||= end_field
      end

      def by_star_start_field
        @by_star_start_field || by_star_field_created_at_field
      end

      def by_star_end_field
        @by_star_end_field || by_star_start_field || by_star_field_created_at_field
      end

      protected

      def by_star_fields_class(options={})
        start_field = options[:field] || by_star_start_field
        end_field = options[:end_field] || options[:field] || by_star_end_field
        [start_field, end_field]
      end

      # Used inside the by_* methods to determine what kind of object "time" is.
      # These methods take the result of the time_klass method, and call other methods
      # using it, such as by_year_Time and by_year_String.
      def time_klass(time)
        case time
          when ActiveSupport::TimeWithZone
            Time
          else
            time.class
        end
      end
    end

    protected

    def by_star_fields_instance(options={})
      start_field = options[:field] || self.class.by_star_start_field
      end_field = options[:end_field] || options[:field] || self.class.by_star_end_field
      [start_field, end_field]
    end
  end
end
