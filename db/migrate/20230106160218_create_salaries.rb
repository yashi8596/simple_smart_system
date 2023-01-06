class CreateSalaries < ActiveRecord::Migration[6.1]
  def change
    create_table :salaries do |t|
      t.integer :wage, null: false
      t.integer :working_hour, null: false
      t.integer :extra_hour, null: false, default: 0
      t.integer :midnight_hour, null: false, default: 0
      t.integer :employee_number, null: false
      t.timestamps
    end
  end
end
