require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:user_id) { 1 }
  let(:token) { JWTHelper.generate_jwt_token({ user_id: user_id }) }
  let(:image) { fixture_file_upload(Rails.root.join('spec/fixtures/files', 'image.png'), 'image/jpeg') }
  let(:valid_headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
  let(:valid_attributes) do
    { name: 'New Product', description: 'Great product', price: 29.99, inventory_count: 10 }
  end

  shared_context 'with authorized headers' do
    before { valid_headers =  {'Authorization': "Bearer #{token}" }}
  end

  shared_examples 'product not found' do
    it 'returns a not found status' do
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /products' do

    it 'creates a new product with valid token' do
      post '/products', params: valid_attributes.to_json, headers: valid_headers
      expect(response).to have_http_status(:created)
    end

    it 'does not create a new product with invalid token' do
      post '/products', params: valid_attributes.to_json, headers: { 'Authorization' => 'Bearer invalid_token' }
      expect(response).to have_http_status(:unauthorized)
    end

    # ... other tests for POST /products ...
  end

  describe 'POST /products with images' do
    let(:valid_attributes_with_images) do
      valid_attributes.merge(images: [image])
    end

    it 'creates a new product and attaches images' do
      post '/products', params: { product: valid_attributes_with_images }, headers: valid_headers.merge('Content-Type': 'multipart/form-data')
      expect(response).to have_http_status(:created)
      expect(Product.last.images).to be_attached
      expect(Product.last.images.count).to be(1)
    end
  end

  describe 'GET /products' do
    include_context 'with authorized headers'

    it 'retrieves a list of products' do
      get '/products', headers: valid_headers
      expect(response).to have_http_status(:ok)
    end
  end

  # describe 'GET /products/:id' do
  #   let(:product) { create(:product, images: [image]) }

  #   it 'retrieves a specific product with images' do
  #     get "/products/#{product.id}", headers: valid_headers
  #     expect(response).to have_http_status(:ok)
  #   end

  #   context 'when product does not exist' do
  #     before { get "/products/non_existing_id", headers: valid_headers }
  #     include_examples 'product not found'
  #   end
  # end

  # describe 'PUT /products/:id' do
  #   let(:product) { create(:product) }
  #   let(:new_attributes) { { name: 'Updated Product' } }

  #   it 'updates the product with valid data' do
  #     put "/products/#{product.id}", params: new_attributes.to_json, headers: valid_headers
  #     expect_response_to_have_http_status_ok
  #     expect(product.reload.name).to eq('Updated Product')
  #   end
  # end

  describe 'DELETE /products/:id' do
    let!(:product) { create(:product) }

    it 'deletes a product' do
      expect {
        delete "/products/#{product.id}", headers: valid_headers
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

end
