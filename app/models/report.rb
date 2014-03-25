  # This is a report from a SQL View
  module Report
    class NullAccount < ActiveRecord::Base

      def to_s
        "#{owner_name}, #{customer_unique_id}"
      end

      def name
        owner_name
      end

      protected

      # The report_state_popularities relation is a SQL view, 
      # so there is no need to try to edit its records ever. 
      # Doing otherwise, will result in an exception being thrown 
      # by the database connection.
      def readonly?
        true
      end
    end # class 

    class DominionReadyAccount < ActiveRecord::Base
      def to_s
        "#{owner_name}, #{acceptedDatapoints}"
      end

      def name
        owner_name
      end

      protected
      def readonly?
        true
      end
    end

    class CvillegasReadyAccount < ActiveRecord::Base
      def to_s
        "#{owner_name}, #{acceptedDatapoints}"
      end

      def name
        owner_name
      end

      protected
      def readonly?
        true
      end
    end
  end # module






