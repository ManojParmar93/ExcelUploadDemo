require 'test_helper'

class ManageUploadsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manage_uploads_index_url
    assert_response :success
  end

  test "should get display_records" do
    get manage_uploads_display_records_url
    assert_response :success
  end

end
