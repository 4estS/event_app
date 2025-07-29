require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(email: "test@example.com", password: "secret", password_confirmation: "secret")
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "secret", password_confirmation: "secret")
    refute user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid without matching password confirmation" do
    user = User.new(email: "test@example.com", password: "secret", password_confirmation: "nope")
    refute user.valid?
  end

  test "authenticates with correct password" do
    user = User.create!(email: "test@example.com", password: "secret", password_confirmation: "secret")
    assert user.authenticate("secret")
  end

  test "does not authenticate with wrong password" do
    user = User.create!(email: "test@example.com", password: "secret", password_confirmation: "secret")
    refute user.authenticate("wrong")
  end
end
