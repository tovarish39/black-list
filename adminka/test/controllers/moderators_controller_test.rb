require "test_helper"

class ModeratorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get moderators_index_url
    assert_response :success
  end
end
