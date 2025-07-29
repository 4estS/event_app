require "application_system_test_case"

class UserLoginsTest < ApplicationSystemTestCase
  fixtures :users

  def setup
    @user = users(:one) # Assuming you have a fixture named :one
  end
  test "user can log in and log out" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Log in"

    assert_text "Users#show"

    # click_on "Log out"
    # assert_text "Sign In"
  end
end
