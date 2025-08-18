require "application_system_test_case"

class UserLoginsTest < ApplicationSystemTestCase
  fixtures :users

  def setup
    @user = users(:one)
  end

  test "user can log in and log out" do
    sign_in_as(@user)

    # (optional) verify we landed on an allowed page happens inside sign_in_as

    # Log out — rack_test can't click data-method="delete" links
    page.driver.submit :delete, sign_out_path, {}

    # Adjust if your SessionsController redirects elsewhere after logout
    assert_current_path root_path
  end
end
