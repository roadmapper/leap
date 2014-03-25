require 'test_helper'

class InstalledMeasureTypesControllerTest < ActionController::TestCase
  setup do
    @installed_measure_type = installed_measure_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:installed_measure_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create installed_measure_type" do
    assert_difference('InstalledMeasureType.count') do
      post :create, installed_measure_type: { installed_measures: @installed_measure_type.installed_measures }
    end

    assert_redirected_to installed_measure_type_path(assigns(:installed_measure_type))
  end

  test "should show installed_measure_type" do
    get :show, id: @installed_measure_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @installed_measure_type
    assert_response :success
  end

  test "should update installed_measure_type" do
    put :update, id: @installed_measure_type, installed_measure_type: { installed_measures: @installed_measure_type.installed_measures }
    assert_redirected_to installed_measure_type_path(assigns(:installed_measure_type))
  end

  test "should destroy installed_measure_type" do
    assert_difference('InstalledMeasureType.count', -1) do
      delete :destroy, id: @installed_measure_type
    end

    assert_redirected_to installed_measure_types_path
  end
end
