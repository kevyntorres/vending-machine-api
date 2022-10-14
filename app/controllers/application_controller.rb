# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request

  ACCEPTED_COINS = [5, 10, 20, 50, 100].freeze

  attr_accessor :current_user

  def buyer_role?
    render json: { message: 'you must have buyer role!' }, status: :unauthorized unless current_user.role == 'buyer'
  end

  def seller_role?
    render json: { message: 'you must have seller role!' }, status: :unauthorized unless current_user.role == 'seller'
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end
end
