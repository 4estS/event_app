require "test_helper"

class GuestLocationControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get guest_location_new_url
    assert_response :success
  end

  test "should get set" do
    get guest_location_set_url
    assert_response :success
  end
end
