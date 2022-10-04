# frozen_string_literal: true

class User < ApplicationRecord
  require 'securerandom'

  ROLES = %w[seller buyer].freeze

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }

  serialize :deposit, Array
end
