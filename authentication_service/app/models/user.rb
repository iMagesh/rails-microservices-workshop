class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, }

  def self.encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base )
  end

  def self.decode_token(token)
    body = JWT.decode(token, Rails.application.credentials.secret_key_base)
    HashWithIndifferentAccess.new body[0]
  end

end
