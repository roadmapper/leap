  # == Schema Information
  #
  # Table name: report_state_popularities
  #
  #  id         :integer
  #  state      :text
  #  country    :string(255)
  #  popularity :integer
  #

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
  end # module






