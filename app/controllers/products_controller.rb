class ProductsController < ApplicationController

  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :validate_seller?, only: [:update, :destroy]
  before_action :buyer_role?, only: [:buy]


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

  def buy
    product = Product.find(buy_params[:productId])
    cost = buy_params[:amount] * product[:cost]
    change = current_user.deposit - cost
    if product.amountAvailable - buy_params[:amount] < 0
      render json: { message: 'product amount available is not enough!' }, status: :bad_request
    elsif change < 0
      render json: { message: 'you need to deposit more coins!' }, status: :bad_request
    else
      current_user.deposit = 0
      current_user.save!
      product.amountAvailable =- buy_params[:amount]
      product.save!
      render json: { product: product.productName, totalSpent: cost, change: change }, status: :ok
    end
  end

  private

  def id
    params[:id]
  end

  def product
    params.permit(:cost, :amountAvailable, :productName)
  end

  def buy_params
    params.permit(:productId, :amount)
  end

  def validate_seller?
    unless current_user.username == Product.find(id)&.sellerId
      render json: { message: 'unauthorized action!'}, status: :unauthorized
    end
  end

end
