class AddRoleToEmployees < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE roles AS ENUM ('warehouse', 'customer_service');
    SQL
    add_column :employees, :role, :roles
    add_index :employees, :role
    Employee.update_all(role: 'warehouse')
  end

  def down
    remove_column :employees, :role
    execute <<-SQL
      DROP TYPE roles
    SQL
  end
end
