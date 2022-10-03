class AddSellerIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sellerId, :string
  end
end
