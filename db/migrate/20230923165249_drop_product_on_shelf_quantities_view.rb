class DropProductOnShelfQuantitiesView < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      DROP VIEW IF EXISTS product_on_shelf_quantities
    SQL
  end

  def down
    execute <<-SQL
      CREATE VIEW product_on_shelf_quantities AS
        SELECT p.id AS product_id,
            count(i.product_id) AS quantity
          FROM (public.products p
            LEFT JOIN public.inventories i ON (((p.id = i.product_id) AND (i.status = 'on_shelf'::public.inventory_statuses))))
        GROUP BY p.id
        ORDER BY p.id
    SQL
  end
end
