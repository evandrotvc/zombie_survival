class CreateInventoryItem < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.references :inventories, foreign_key: true, index: true
      t.references :items, foreign_key: true, index: true
      t.timestamps
    end
  end
end
