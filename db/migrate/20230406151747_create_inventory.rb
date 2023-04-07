class CreateInventory < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end

    add_reference :items, :inventory, foreign_key: true, index: true
  end
end
