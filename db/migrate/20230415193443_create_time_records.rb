class CreateTimeRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :time_records do |t|
      t.string :employee_id, null: false
      t.datetime :started_at, null: false
      t.datetime :finished_at
      t.float :total_time, default: 0.0, null: false
      t.float :absent_time, default: 0.0, null: false
      t.float :extra_time, default: 0.0, null: false
      t.float :night_time, default: 0.0, null: false
      t.timestamps
    end
  end
end
