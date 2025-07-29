class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  validates :email, presence: true, uniqueness: true
end
