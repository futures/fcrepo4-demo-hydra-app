class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :perm_type
      t.string :collection_id

      t.timestamps
    end

    add_index :permissions, :user_id
    add_index :permissions, :collection_id
    add_index :permissions, [:user_id, :collection_id], :unique=>true
  end

end
