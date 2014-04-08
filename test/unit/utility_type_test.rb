require 'test_helper'

class UtilityTypeTest < ActiveSupport::TestCase
  
  test "should save utilitytype given id" do
	    @util = UtilityType.new(
	      :id => "0")
	    assert @util.save
  end


  test "should save utilitytype with all fields" do
	    @util = UtilityType.new(
	      :id => "0",
	      :typeName => "electricity",
	      :units => "Kwh")
	    assert @util.save	
  end

  test "should not save null utilitytype" do
	    @util = UtilityType.new
	    assert @util.save
  end
  
  test "should destroy existing utilitytype" do
	    @util = UtilityType.new(
	      :id => "0")
	    @util.save
	    @util.destroy
	     assert_raise(ActiveRecord::RecordNotFound) {
      User.find(@util.id)
    }
  end
  
  test "should update existing utilitytype" do
	    @util = UtilityType.new(
	      :id => "0")
	    @util.save
	    @util.id = "1"
	    assert @util.save
  end


  test "should update typename, units" do
	    @util = UtilityType.new(
	      :id => "0",
	      :typeName => "electricity",
	      :units => "Kwh")
	    @util.save
	    @util.typeName = "test"
	    @util.units = "test2"
	    assert_equal "test", @util.typeName
	    assert_equal "test2", @util.units
  end

end
