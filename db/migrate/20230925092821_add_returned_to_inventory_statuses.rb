class AddReturnedToInventoryStatuses < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE inventory_statuses ADD VALUE IF NOT EXISTS 'returned';
    SQL
  end

  def down
    # Removing an enum value isn't supported in Postgres
    # If we really want to drop the value, the only way is to
    # remove the enum and add a new type with the values we want
    #
    # For simplicity, we can assume here that we won't need to
    # remove the `returned` value
  end
end
