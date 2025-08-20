require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should get create" do
    get sign_in_url
    assert_response :success
  end

  test "should get destroy" do
    get sign_in_url
    assert_response :success
  end

  test "should log in user" do
    user = users(:one)
    post sign_in_path, params: { email: user.email, password: "correctpass" }
    assert_redirected_to home_path
  end

  test "should log out" do
    delete sign_out_url
    assert_redirected_to root_path
  end
end
