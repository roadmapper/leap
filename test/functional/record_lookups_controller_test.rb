require 'test_helper'

class RecordLookupsControllerTest < ActionController::TestCase
  setup do
    @record_lookup = record_lookups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:record_lookups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create record_lookup" do
    assert_difference('RecordLookup.count') do
      post :create, record_lookup: { acct_num: @record_lookup.acct_num, company_name: @record_lookup.company_name }
    end

    assert_redirected_to record_lookup_path(assigns(:record_lookup))
  end

  test "should show record_lookup" do
    get :show, id: @record_lookup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @record_lookup
    assert_response :success
  end

  test "should update record_lookup" do
    put :update, id: @record_lookup, record_lookup: { acct_num: @record_lookup.acct_num, company_name: @record_lookup.company_name }
    assert_redirected_to record_lookup_path(assigns(:record_lookup))
  end

  test "should destroy record_lookup" do
    assert_difference('RecordLookup.count', -1) do
      delete :destroy, id: @record_lookup
    end

    assert_redirected_to record_lookups_path
  end
end
