require 'test_helper'

class PowerRecordingsControllerTest < ActionController::TestCase
  setup do
    @power_recording = power_recordings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:power_recordings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create power_recording" do
    assert_difference('PowerRecording.count') do
      post :create, :power_recording => @power_recording.attributes
    end

    assert_redirected_to power_recording_path(assigns(:power_recording))
  end

  test "should show power_recording" do
    get :show, :id => @power_recording.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @power_recording.to_param
    assert_response :success
  end

  test "should update power_recording" do
    put :update, :id => @power_recording.to_param, :power_recording => @power_recording.attributes
    assert_redirected_to power_recording_path(assigns(:power_recording))
  end

  test "should destroy power_recording" do
    assert_difference('PowerRecording.count', -1) do
      delete :destroy, :id => @power_recording.to_param
    end

    assert_redirected_to power_recordings_path
  end
end
