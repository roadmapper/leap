require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
include Devise::TestHelpers
   setup do
     @upload = uploads(:one)
   end

   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:uploads)
   end

   test "should create upload" do
     assert_difference('Upload.count') do
       post :create, upload: { file_name: @upload.file_name, process_date: @upload.process_date, status: @upload.status, status: @upload.status, upload_date: @upload.upload_date, uploaded_by: @upload.uploaded_by }
     end

     assert_redirected_to upload_path(assigns(:upload))
   end


   test "should update upload" do
     put :update, id: @upload, upload: { file_name: @upload.file_name, process_date: @upload.process_date, status: @upload.status, status: @upload.status, upload_date: @upload.upload_date, uploaded_by: @upload.uploaded_by }
     assert_redirected_to upload_path(assigns(:upload))
   end

   test "should destroy upload" do
     assert_difference('Upload.count', -1) do
       delete :destroy, id: @upload
     end
   end

   test "should not upload" do
	assert_equal("Duplicate file found in uploads, file not uploaded", upload.upload_file)
   end
  #   assert_redirected_to uploads_path
  # end
end
