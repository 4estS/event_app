# test/system/remember_me_test.rb
require "application_system_test_case"

class RememberMeTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: "remember@example.com", password: "longpassword")
  end

  test "remembered login persists after session cookie is cleared" do
    visit sign_in_path
    fill_in "email", with: @user.email
    fill_in "password", with: "longpassword"
    check "remember_me"
    click_button "Log in"
    assert_current_path home_path

    delete_session_cookie!  # <-- use the helper

    visit home_path
    assert_current_path home_path
  end

  private

  def delete_session_cookie!
    session_key = Rails.application.config.session_options[:key]

    # RackTest (default system test driver)
    if page.driver.browser.respond_to?(:rack_mock_session)
      page.driver.browser.rack_mock_session.cookie_jar.delete(session_key)
      return
    end

    # Selenium (if you ever switch to it)
    if page.driver.browser.respond_to?(:manage)
      page.driver.browser.manage.delete_cookie(session_key)
      return
    end

    raise "Unsupported Capybara driver for cookie manipulation"
  end
end
