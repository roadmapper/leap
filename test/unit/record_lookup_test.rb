require 'test_helper'

class RecordLookupTest < ActiveSupport::TestCase
   #Property creation tests
  test "property_id creation validation" do
  	rl = RecordLookup.new :utility_type_id=>"0", :company_name=>"DOMINION", :acct_num=>"123456789"
  	assert !rl.save
  end

  test "utility_type_id creation validation" do
  	rl = RecordLookup.new :property_id=>"123", :company_name=>"DOMINION", :acct_num=>"123456789"
  	assert !rl.save
  end

  test "company_name creation validation" do
  	rl = RecordLookup.new :property_id=>"123", :utility_type_id=>"0", :acct_num=>"123456789"
  	assert !rl.save
  end

  test "acct_num creation validation" do
  	rl = RecordLookup.new :property_id=>"123", :utility_type_id=>"0", :company_name=>"DOMINION"
  	assert !rl.save
  end
end
