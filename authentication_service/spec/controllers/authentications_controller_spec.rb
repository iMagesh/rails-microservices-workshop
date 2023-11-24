require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do

  describe 'POST #register' do
    let(:valid_attributes) {
      {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
    let(:invalid_attributes) {
      {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'wrong'
      }
    }

    context 'with valid parameters' do
      before { post :register, params: valid_attributes }

      it 'creates a User' do
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include("application/json")
        expect(response.content_type). to include("charset=utf-8")
      end
    end

    context 'with invalid parameters' do
      before { post :register, params: invalid_attributes }

      it 'does not create a User' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST #login' do
    let(:user) { create(:user, email: 'user@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'logs in the user' do
        post :login, params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
      end
    end
  end
end
