class AddColumnsToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :prev_grant_date, :date
    add_column :employees, :next_grant_date, :date, null: false
    add_column :employees, :granted, :boolean, null: false, default: false
  end
end
