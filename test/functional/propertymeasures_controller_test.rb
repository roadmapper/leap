require 'test_helper'

class PropertymeasuresControllerTest < ActionController::TestCase
  setup do
    @propertymeasure = propertymeasures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:propertymeasures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create propertymeasure" do
    assert_difference('Propertymeasure.count') do
      post :create, propertymeasure: { comment: @propertymeasure.comment }
    end

    assert_redirected_to propertymeasure_path(assigns(:propertymeasure))
  end

  test "should show propertymeasure" do
    get :show, id: @propertymeasure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @propertymeasure
    assert_response :success
  end

  test "should update propertymeasure" do
    put :update, id: @propertymeasure, propertymeasure: { comment: @propertymeasure.comment }
    assert_redirected_to propertymeasure_path(assigns(:propertymeasure))
  end

  test "should destroy propertymeasure" do
    assert_difference('Propertymeasure.count', -1) do
      delete :destroy, id: @propertymeasure
    end

    assert_redirected_to propertymeasures_path
  end
end
