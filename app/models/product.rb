# frozen_string_literal: true

class Product < ApplicationRecord
  validates :productName, presence: true, uniqueness: true
  validates :sellerId, presence: true
  validates :amountAvailable, presence: true
  validates :cost, presence: true

  validate :valid_cost, :valid_amount

  def valid_cost
    errors.add(:cost, 'must be multiple of 5!') unless (cost % 5).zero?
  end

  def valid_amount
    errors.add(:amountAvailable, 'cannot be negative!') if amountAvailable.negative?
  end
end
