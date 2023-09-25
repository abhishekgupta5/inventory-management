class AddIndexToOrderState < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    add_index :orders, :state, algorithm: :concurrently
  end
end
