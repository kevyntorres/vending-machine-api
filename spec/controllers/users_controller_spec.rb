# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) do
    User.new(
      username: 'buyer',
      password: 'test',
      role: 'buyer',
      deposit: []
    )
  end
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return true
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return user
  end

  describe 'POST /deposit' do
    params = {
      "coin": 50
    }

    it 'deposit successfully' do
      post '/deposit', params: params

      expect(response).to be_successful
      expect(user.deposit).to eq([50])
    end
  end

  describe 'POST /reset' do
    it 'reset deposit successfully' do
      post '/reset'

      expect(response).to be_successful
      expect(user.deposit).to eq([])
    end
  end
end
