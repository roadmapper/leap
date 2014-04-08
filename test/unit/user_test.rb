require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save null user" do
  	user = User.new
  	assert !user.save
  end

  test "should delete any user" do
  	user = User.new
  	assert user.delete
  end

  test "should create user given password and email" do
    @user = User.new(
      :email => "test@test.com",
      :password => "password",
      :password_confirmation => "password"
    )
 
    assert @user.save
  end

  test "should not save user with incorrect email format" do
  	user = User.new(
      :email => "test",
      :password => "password",
      :password_confirmation => "password"
    )
    assert !user.save
    end


  test "should not save user with null password" do
  	user = User.new(
      :email => "test",
      :password => "",
      :password_confirmation => "password"
    )
    assert !user.save
    end  


  test "should not save user with null email" do
  	user = User.new(
      :email => "",
      :password => "password",
      :password_confirmation => "password"
    )
    assert !user.save
    end  

  test "should update user password" do
  	user = User.new(
      :email => "test@test.com",
      :password => "password",
      :password_confirmation => "password"
    )
    user.save
  	user.password = "testpassword"
  	user.password_confirmation = "testpassword"
  	assert user.save
  end

  test "should destroy user" do
  	user = User.new(
      :email => "test@test.com",
      :password => "password",
      :password_confirmation => "password"
    )
    user.save
  	user.destroy
    assert_raise(ActiveRecord::RecordNotFound) {
      User.find(user.email)
    }
  end
end
