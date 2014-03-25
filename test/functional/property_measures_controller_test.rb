require 'test_helper'

class PropertyMeasuresControllerTest < ActionController::TestCase
  setup do
    @property_measure = property_measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:property_measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create property_measure" do
    assert_difference('PropertyMeasure.count') do
      post :create, property_measure: { comment: @property_measure.comment }
    end

    assert_redirected_to property_measure_path(assigns(:property_measure))
  end

  test "should show property_measure" do
    get :show, id: @property_measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @property_measure
    assert_response :success
  end

  test "should update property_measure" do
    put :update, id: @property_measure, property_measure: { comment: @property_measure.comment }
    assert_redirected_to property_measure_path(assigns(:property_measure))
  end

  test "should destroy property_measure" do
    assert_difference('PropertyMeasure.count', -1) do
      delete :destroy, id: @property_measure
    end

    assert_redirected_to property_measures_path
  end
end
