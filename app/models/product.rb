# frozen_string_literal: true

class Product < ApplicationRecord
  validates :productName, presence: true, uniqueness: true
  validates :sellerId, presence: true
  validates :amountAvailable, presence: true
  validates :cost, presence: true
end
