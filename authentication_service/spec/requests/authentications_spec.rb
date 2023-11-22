require 'rails_helper'

# Define shared examples at the beginning of the file
RSpec.shared_examples 'a registration error' do |error_message, extra_params|
  let(:user_count) { 1 }
  it "returns error when #{error_message}" do
    post '/register', params: { email: 'existing@example.com', password: 'password', password_confirmation: 'password' }.merge(extra_params)
    expect(User.count).to be(user_count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response['errors']).to include(error_message)
  end
end

RSpec.describe 'Authentications', type: :request do

  before(:all) do
    User.create(
      email: "alreadytaken@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  describe 'POST /register' do
    let(:valid_attributes) do
      { email: 'test@example.com', password: 'password', password_confirmation: 'password' }
    end

    let(:invalid_attributes) do
      valid_attributes.merge(password_confirmation: 'wrong')
    end

    context 'with valid parameters' do
      before { post '/register', params: valid_attributes }

      it 'creates a User' do
        expect(User.count).to eq(2) # we are creating 1 user in before(:all)
        expect(User.last.email).to eq(valid_attributes[:email])
      end

      it 'returns a JWT token' do
        expect(response).to have_http_status(:created)
        expect(json_response['token']).not_to be_nil
      end

      it 'returns a success message' do
        expect(json_response['message']).to eq('User created successfully')
      end
    end

    context 'with invalid parameters' do
      it_behaves_like 'a registration error', 'Email has already been taken', email: "alreadytaken@example.com"
      it_behaves_like 'a registration error', "Email can't be blank", email: ''
      it_behaves_like 'a registration error', "Password can't be blank", password: '', password_confirmation: ''
      it_behaves_like 'a registration error', "Password confirmation doesn't match Password", email: 'test@example.com', password_confirmation: "pass"
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@.com'
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@gmail#.com'
      it_behaves_like 'a registration error', "Password is too short (minimum is 8 characters)", password: 'short', password_confirmation: 'short'
      it_behaves_like 'a registration error', "Password is too long (maximum is 15 characters)", password: 'itstoolongpassword', password_confirmation: 'itstoolongpassword'
    end
  end
end
