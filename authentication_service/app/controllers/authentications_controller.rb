class AuthenticationsController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      token = User.encode_token({user_id: user.id})
      render json: {user: user, token: token, message: "User created successfully"}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def login
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
