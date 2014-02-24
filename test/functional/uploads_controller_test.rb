require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
include Devise::TestHelpers
  test "the truth" do
    assert true
  end
  # setup do
  #   @upload = uploads(:one)
  # end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:uploads)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create upload" do
  #   assert_difference('Upload.count') do
  #     post :create, upload: { file_name: @upload.file_name, process_date: @upload.process_date, status: @upload.status, status: @upload.status, upload_date: @upload.upload_date, uploaded_by: @upload.uploaded_by }
  #   end

  #   assert_redirected_to upload_path(assigns(:upload))
  # end

  # test "should show upload" do
  #   get :show, id: @upload
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @upload
  #   assert_response :success
  # end

  # test "should update upload" do
  #   put :update, id: @upload, upload: { file_name: @upload.file_name, process_date: @upload.process_date, status: @upload.status, status: @upload.status, upload_date: @upload.upload_date, uploaded_by: @upload.uploaded_by }
  #   assert_redirected_to upload_path(assigns(:upload))
  # end

  # test "should destroy upload" do
  #   assert_difference('Upload.count', -1) do
  #     delete :destroy, id: @upload
  #   end

  #   assert_redirected_to uploads_path
  # end
end
