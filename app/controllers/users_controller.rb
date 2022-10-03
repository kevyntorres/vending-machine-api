class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

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

  private

  def id
    params[:id]
  end

  def user_params
    params.permit(:username, :password, :role, :deposit)
  end
end
