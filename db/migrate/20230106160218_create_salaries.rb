class CreateSalaries < ActiveRecord::Migration[6.1]
  def change
    create_table :salaries do |t|
      t.string :employee_id, null: false
      t.integer :wage, null: false
      t.integer :total_hour, default: 0, null: false
      t.integer :extra_hour, default: 0, null: false
      t.integer :absent_hour, default: 0, null: false
      t.float :total_minute, default: 0.0, null: false
      t.float :extra_minute, default: 0.0, null: false
      t.float :absent_minute, default: 0.0, null: false
      t.integer :absent_days, default: 0, null: false
      t.integer :run_days, default: 0, null: false
      t.integer :used_paid_leave, default: 0, null: false
      t.integer :range_year, null: false
      t.integer :range_month, null: false
      t.timestamps
    end
  end
end
