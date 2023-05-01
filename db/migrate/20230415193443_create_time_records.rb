class CreateTimeRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :time_records do |t|
      t.string :employee_id, null: false
      t.date :work_date
      t.time :started_at
      t.time :finished_at
      t.float :total_time
      t.float :absent_time
      t.float :extra_time
      t.integer :division
      t.timestamps
    end
  end
end
