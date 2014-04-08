require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
#Property creation tests
  test "zip creation validation" do
  	property = Property.new :owner_name=>"test1", :street_address=>"123 fake street", :city=>"CVille", :state=>"VA"
  	assert !property.save
  end

  test "owner_name creation validation" do
  	property = Property.new :street_address=>"123 fake street", :city=>"CVille", :state=>"VA", :zipcode=>"22180"
  	assert !property.save
  end

  test "street_address creation validation" do
  	property = Property.new :owner_name=>"test1", :city=>"CVille", :state=>"VA", :zipcode=>"22180"
  	assert !property.save
  end

  test "state creation validation" do
  	property = Property.new :owner_name=>"test1", :street_address=>"123 fake street", :city=>"CVille", :zipcode=>"22180"
  	assert !property.save
  end

  test "city creation validation" do
  	property = Property.new :owner_name=>"test1", :street_address=>"123 fake street", :state=>"VA", :zipcode=>"22180"
  	assert !property.save
  end
end
