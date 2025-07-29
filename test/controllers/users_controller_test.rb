require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to user_path(User.last)
  end

  test "should get show" do
    user = User.create!(
      email: "show@example.com",
      password: "secret",
      password_confirmation: "secret"
    )

    login_as(user)
    get user_url(user)
    assert_response :success
  end
end
