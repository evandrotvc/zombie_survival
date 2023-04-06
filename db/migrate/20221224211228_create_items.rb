class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.integer :point, null: false
      t.string :kind, null: false
      t.timestamps
    end
  end
end
