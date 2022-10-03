class SetDepositDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :deposit, 0
  end
end
