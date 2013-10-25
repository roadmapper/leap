require 'test_helper'

class GasRecordingsControllerTest < ActionController::TestCase
  setup do
    @gas_recording = gas_recordings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gas_recordings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gas_recording" do
    assert_difference('GasRecording.count') do
      post :create, :gas_recording => @gas_recording.attributes
    end

    assert_redirected_to gas_recording_path(assigns(:gas_recording))
  end

  test "should show gas_recording" do
    get :show, :id => @gas_recording.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @gas_recording.to_param
    assert_response :success
  end

  test "should update gas_recording" do
    put :update, :id => @gas_recording.to_param, :gas_recording => @gas_recording.attributes
    assert_redirected_to gas_recording_path(assigns(:gas_recording))
  end

  test "should destroy gas_recording" do
    assert_difference('GasRecording.count', -1) do
      delete :destroy, :id => @gas_recording.to_param
    end

    assert_redirected_to gas_recordings_path
  end
end
