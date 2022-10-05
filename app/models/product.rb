# frozen_string_literal: true

class Product < ApplicationRecord
  validates :productName, presence: true, uniqueness: true
  validates :sellerId, presence: true
  validates :amountAvailable, presence: true
  validates :cost, presence: true

  validate :valid_cost, :valid_amount

  def valid_cost
    unless cost % 5 == 0
      errors.add(:cost, "must be multiple of 5!")
    end
  end

  def valid_amount
    if amountAvailable < 0
      errors.add(:amountAvailable, "cannot be negative!")
    end
  end
end
