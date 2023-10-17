class AddFixedToAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :fixed, :boolean, default: true
    add_index :addresses, :fixed
    update_addresses
  end

  def update_addresses
    not_fixed = Order.returned.pluck(:ships_to_id)
    Address.where(id: not_fixed).update_all(fixed: false)
  end
end
