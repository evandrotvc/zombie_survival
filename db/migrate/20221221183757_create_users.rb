class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :gender
      t.string :status, default: 'survivor'
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.integer :age, null: false
      t.integer :marks, null: false, default: 0

      t.timestamps
    end
  end
end
