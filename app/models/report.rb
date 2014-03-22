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

    class UtilityReady
      include PropertiesHelper
      @@owner_name = nil
      @@account_number = nil
      @@readings = nil
      def initialize(property_id, utility_type_id)
        property = Property.find(property_id)
        @@owner_name = property.owner_name
        lookup = RecordLookup.where("property_id = ? AND utility_type_id = ?", property.id, utility_type_id)
        @@account_number = lookup.acctnum
        recordings = get_records(lookup, start_date(property.finish_date), end_date(property.finish_date))
        @@readings = get_data_count(recordings, start_date(property.finish_date))
      end
    end
  end # module






