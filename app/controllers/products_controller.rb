class ProductsController < ApplicationController

  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :validate_seller?, only: [:update, :destroy]

  def index
    products = Product.all
    render json: products, status: :ok
  end

  def show
    render json: Product.find(id), status: :ok
  end

  def create
    new_product = Product.create(product.merge!('sellerId': current_user.username))
    if new_product.save
      render json: { id: new_product.id }, status: :ok
    else
      render json: { errors: new_product.errors }, status: :bad_request
    end
  end

  def update
    existing_product = Product.find(id)

    if existing_product.update(product)
      render json: { id: existing_product.id }, status: :ok
    else
      render json: { errors: existing_product.errors }, status: :bad_request
    end
  end

  def destroy
    product = Product.find(id)
    product.destroy!
    render json: {}, status: :ok
  end

  def id
    params[:id]
  end

  def product
    params.permit(:cost, :amountAvailable, :productName)
  end

  def validate_seller?
    unless current_user.username == Product.find(id)&.sellerId
      render json: { message: 'unauthorized action!'}, status: :unauthorized
    end
  end

end
