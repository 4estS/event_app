require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "shows user when signed in" do
    sign_in_as(@user) # helper from test_helper.rb, default password "correctpass"
    get user_url(@user)
    assert_response :success
  end
end
