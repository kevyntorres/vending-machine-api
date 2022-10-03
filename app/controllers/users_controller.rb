class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :buyer_role?, only: [:deposit, :reset_deposit]

  ACCEPTED_COINS = [5, 10, 20, 50, 100].freeze

  def index
    users = User.all
    render json: users, status: :ok
  end

  def show
    render json: User.find(id), status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :bad_request
    end
  end

  def update
    existing_user = User.find(id)

    if existing_user.update(user_params)
      render json: { id: existing_user.id }, status: :ok
    else
      render json: { errors: existing_user.errors }, status: :bad_request
    end
  end

  def destroy
    user = User.find(id)
    user.destroy!
    render json: {}, status: :ok
  end

  def deposit
    coin = deposit_params[:coin].to_i
    if ACCEPTED_COINS.include?(coin)
      current_user.deposit.present? ? current_user.deposit << coin : current_user.deposit = Array.wrap(coin)
      current_user.save!
      render json: { message: 'Deposit completed successfully!', deposit: current_user.deposit }, status: :ok
    else
      render json: { errors: 'coin not accepted!' }, status: :bad_request
    end
  end

  def reset_deposit
    current_user.deposit = []
    current_user.save!
    render json: { message: 'Deposit has been resetted!', deposit: current_user.deposit }, status: :ok
  end

  private

  def id
    params[:id]
  end

  def deposit_params
    params.permit(:coin)
  end

  def user_params
    params.permit(:username, :password, :role)
  end
end
