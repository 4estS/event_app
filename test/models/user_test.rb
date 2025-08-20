require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(email: "new@example.com", password: "correctpass", password_confirmation: "correctpass")
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "correctpass", password_confirmation: "correctpass")
    refute user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid without matching password confirmation" do
    user = User.new(email: "test@example.com", password: "correctpass", password_confirmation: "nope")
    refute user.valid?
  end

  test "authenticates with correct password (fixture)" do
    user = users(:one)
    assert user.authenticate("correctpass")   # matches the fixture digest
  end

  test "does not authenticate with wrong password (fixture)" do
    user = users(:one)
    refute user.authenticate("wrong")
  end

  test "remember/forget roundtrip" do
    user = users(:one)
    token = user.remember!(ttl: 1.day)
    assert user.remembered?(token)
    refute user.remembered?("bad")
    user.forget!
    refute user.remembered?(token)
  end
end
