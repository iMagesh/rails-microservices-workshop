require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  describe "POST /register" do
    let(:valid_attributes) do
      {
        email: "magesh@gmail.com",
        password: "password",
        password_confirmation: "password"
      }
    end

    let(:invalid_attributes) do
      {
        email: "magesh@gmail.com",
        password: "password",
        password_confirmation: "wrong"
      }
    end

    context "with valid parameters" do

      before do
        post '/register', params: valid_attributes
      end

      it "creates a User" do
        expect(User.count).to be(1)
        expect(User.last.email).to eq(valid_attributes[:email])
      end

      it "returns a JWT token" do
        # post '/register', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(json_response['token']).not_to be_nil
      end

      it "returns a success message" do
        expect(json_response['message']).to eq('User created successfully')
      end

    end

    context "with invalid parameters" do

      before do
        User.create(
          email: "tanya@gmail.com",
          password: "password",
          password_confirmation: "password"
        )
      end

      it "does not create the User" do
        post '/register', params: invalid_attributes
        expect(User.count).to be(1)
      end

      it 'returns and error if email already exists' do
        post '/register', params: {
                                    email: "tanya@gmail.com",
                                    password: "anything",
                                    password_confirmation: "anything"
                                  }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email has already been taken")
      end

      it "returns error when email is not present" do
        post '/register', params: {
                                    email: "",
                                    password: "anything",
                                    password_confirmation: "anything"
                                  }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email can't be blank")
      end

      it "returns error when password is not present" do
        post '/register', params: {
                                    email: "magesh@magesh.com",
                                    password: "",
                                    password_confirmation: ""
                                  }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Password can't be blank")
      end

      it "returns error when password doesn't match the confirmation" do
        post '/register', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Password confirmation doesn't match Password")
      end

      it "returns error when email is invalid" do
        post '/register', params: {
                                    email: "magesh@.com",
                                    password: "password",
                                    password_confirmation: "password"
                                  }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email is invalid")
      end

      it "returns error when params is empty" do
        post '/register', params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Email can't be blank", "Password can't be blank", "Email is invalid")
      end
    end
  end
end
