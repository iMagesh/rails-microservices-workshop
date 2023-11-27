module JWTHelper
  JWT_SECRET = Rails.application.credentials.secret_key_base

  def self.generate_jwt_token(payload)
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end
end
