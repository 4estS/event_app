require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "redirects guests to sign in" do
    get dashboard_url
    assert_redirected_to sign_in_path
  end

  test "renders dashboard for signed-in users" do
    sign_in_as(@user)         # <-- helper from test_helper.rb
    get dashboard_url
    assert_response :success
  end
end
