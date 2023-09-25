class AddOrderStateEnum < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE order_states AS ENUM ('in_progress', 'fulfilled', 'returned');
    SQL
    add_column :orders, :state, :order_states, null: false, default: 'in_progress'
    update_state_for_orders
  end

  def down
    remove_column :orders, :state
    execute <<-SQL
      DROP TYPE order_states
    SQL
  end

  def update_state_for_orders
    Order.find_each do |order|
      state = order.fulfilled? ? 'fulfilled' : 'in_progress'
      order.update!(state:)
    end
  end
end
