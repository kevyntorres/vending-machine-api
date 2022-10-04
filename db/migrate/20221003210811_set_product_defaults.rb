# frozen_string_literal: true

class SetProductDefaults < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :amountAvailable, 0
  end
end
