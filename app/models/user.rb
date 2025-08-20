class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  validates :email, presence: true, uniqueness: true

  has_many :events, dependent: :destroy

  # --- Remember-me support ---
  attr_accessor :remember_token

  def self.digest(raw)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(raw, cost: cost)
  end

  # Generates a token, saves its digest, and returns the *raw* token (for cookie).
  def remember!(ttl: 30.days)
    self.remember_token = SecureRandom.urlsafe_base64(32)
    update_columns(
      remember_digest: self.class.digest(remember_token),
      remember_created_at: Time.current
    )
    remember_token
  end

  # Verifies a presented token against the digest.
  def remembered?(token)
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  # Optional TTL check (lets us expire long‑lived cookies server‑side).
  def remember_expired?(ttl: 30.days)
    remember_created_at.blank? || remember_created_at < ttl.ago
  end

  # Clears the digest.
  def forget!
    update_columns(remember_digest: nil, remember_created_at: nil)
  end
end
