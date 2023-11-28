class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :destroy]
  before_action :authenticate_user, only: [:create, :destroy]

  def index
    @products = Product.all
    render json: @products
  end

  def show
    render json: @product, status: :ok
  end

  def details
    @products = Product.where(id: params[:product_ids].split(','))
    render json: @products, status: :ok
  end

  def create
    @product = Product.new(product_params.except(:images))
    attach_images if product_params[:images]

    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors}, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    if @product.destroy
      head :no_content
    else
      head :internal_server_error
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Product not found' }, status: :not_found
  end

  def attach_images
    product_params[:images].each do |image|
      @product.images.attach(image)
    end
  end

  def product_with_images
    @product.as_json.merge(images: @product.image_urls)
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, images: [])
  end
end
