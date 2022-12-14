# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :validate_seller?, only: %i[update destroy]
  before_action :buyer_role?, only: [:buy]
  before_action :seller_role?, only: [:create]

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
    cost = amount * product[:cost].to_i
    change = deposit_amount - cost
    if (product.amountAvailable - amount).negative?
      render json: { message: 'product amount available is not enough!' }, status: :bad_request
    elsif change.negative?
      render json: { message: 'you need more coins to buy it!' }, status: :bad_request
    else
      current_user.deposit = []
      current_user.save!
      product.amountAvailable = product.amountAvailable - amount
      product.save!
      render json: { product: product.productName, totalSpent: cost, change: change_array(change) }, status: :ok
    end
  end

  private

  def id
    params[:id]
  end

  def deposit_amount
    current_user.deposit.inject(0, :+)
  end

  def change_array(change)
    [].tap do |array|
      ACCEPTED_COINS.reverse.each do |coin|
        next if change < coin

        change = change_calc(change, coin, array)
      end
    end
  end

  def change_calc(change, coin, arr)
    rest = change % coin
    (change / coin).times { arr << coin }
    if rest >= coin && rest.positive?
      change_calc(rest, coin, arr)
    else
      rest
    end
  end

  def product
    params.permit(:cost, :amountAvailable, :productName)
  end

  def buy_params
    params.permit(:productId, :amount)
  end

  def amount
    buy_params[:amount].to_i
  end

  def validate_seller?
    return if current_user.username == Product.find(id)&.sellerId

    render json: { message: 'unauthorized action!' }, status: :unauthorized
  end
end
