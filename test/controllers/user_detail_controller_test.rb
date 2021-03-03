require 'test_helper'

class UserDetailControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_detail_index_url
    assert_response :success
  end

end
