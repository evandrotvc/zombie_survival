class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.integer :point, null: false
      t.integer :quantity, null: false, default: 0
      t.string :kind, null: false
      t.timestamps
    end
  end
end
