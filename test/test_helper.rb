# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require_relative "support/system_helpers"
class ActionDispatch::SystemTestCase
  include SystemHelpers
end

require "bcrypt"
ActiveModel::SecurePassword.min_cost = true

module AuthHelpers
  # Signs in via SessionsController#create
  def sign_in_as(user, password: "correctpass", remember_me: "0")
    post sign_in_path, params: { email: user.email, password:, remember_me: remember_me }
    follow_redirect! if response.redirect?
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

# Make the helper available to request/controller tests
class ActionDispatch::IntegrationTest
  include AuthHelpers
end
