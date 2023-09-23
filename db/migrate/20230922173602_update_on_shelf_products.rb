class UpdateOnShelfProducts < ActiveRecord::Migration[7.0]
  def up
    ActiveRecord::Base.transaction do
      execute <<-SQL
        LOCK TABLE inventories, products IN SHARE MODE
      SQL

      products_on_shelf_data.map do |data|
        Product.find(data['product_id']).update(on_shelf: data['quantity'])
      end
    end
  end

  def down
    products_on_shelf_data.map do |data|
      Product.find(data['product_id']).update(on_shelf: nil)
    end
  end

  def products_on_shelf_data
    execute <<-SQL
      SELECT product_id, quantity
      FROM product_on_shelf_quantities
    SQL
  end
end
