class CreateMarkSurvivor < ActiveRecord::Migration[7.0]
  def change
    create_table :mark_survivors do |t|
      t.references :user_report, foreign_key: { to_table: 'users' }, index: true
      t.references :user_marked, foreign_key: { to_table: 'users' }, index: true
      t.index  %i[user_report_id user_marked_id], unique: true
      t.timestamps
    end
  end
end
