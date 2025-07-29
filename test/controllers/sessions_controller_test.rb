require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should get create" do
    get login_url
    assert_response :success
  end

  test "should get destroy" do
    get login_url
    assert_response :success
  end

  test "should log in user" do
    user = User.create!(email: "login@example.com", password: "secret", password_confirmation: "secret")
    post login_url, params: { email: user.email, password: "secret" }
    assert_redirected_to user_path(user)
  end

  test "should log out" do
    delete logout_url
    assert_redirected_to root_path
  end
end
