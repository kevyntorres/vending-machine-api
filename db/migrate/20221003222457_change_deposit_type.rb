# frozen_string_literal: true

class ChangeDepositDefault2 < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :deposit, :string
  end
end
