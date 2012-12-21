class CreatePermTypes < ActiveRecord::Migration
  def change
    create_table :perm_types do |t|
      t.string :label
      t.string :code
      t.timestamps
    end

    add_index :perm_types, :code, :unique=>true
  end
end
