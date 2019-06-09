require 'test_helper'

class DataControllerTest < ActionDispatch::IntegrationTest
  test "should get raw" do
    get data_raw_url
    assert_response :success
  end

end
