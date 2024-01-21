require 'test_helper'

class ScamersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get scamers_index_url
    assert_response :success
  end
end
