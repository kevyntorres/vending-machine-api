class User < ApplicationRecord
  require 'securerandom'

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
end
