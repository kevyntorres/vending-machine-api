# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:user) do
    User.new(
      username: 'buyer',
      password: 'test',
      role: 'buyer',
      deposit: [0]
    )
  end
  before do
    Product.new(
      amountAvailable: 1,
      cost: 15,
      productName: 'testABCD',
      sellerId: 'seller'
    ).save!

    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return true
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return user
  end

  describe 'POST /buy' do
    params = {
      "amount": 1,
      "productId": 1
    }

    it 'fail to buy a product due to lack of coins' do
      post '/buy', params: params

      expect(response).not_to be_successful
      expect(response.body).to eq("{\"message\":\"you need more coins to buy it!\"}")
    end

    it 'buy a product successfully' do
      user[:deposit] = [100]
      user.save!

      post '/buy', params: params

      expect(response).to be_successful
    end
  end

  describe 'POST /products' do
    let(:seller_user) do
      User.new(
        username: 'seller',
        password: 'test',
        role: 'seller'
      )
    end
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return seller_user
    end

    it 'creates product successfully' do
      params = {
        "amountAvailable": 10,
        "cost": 30,
        "productName": "new product"
      }

      post '/products', params: params

      expect(response).to be_successful
    end
  end
end
