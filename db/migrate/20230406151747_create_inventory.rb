class CreateInventory < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :users, foreign_key: true, index: true
      t.references :items, foreign_key: true, index: true
      t.timestamps
    end
  end
end
