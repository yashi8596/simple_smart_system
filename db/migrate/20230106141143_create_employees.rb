class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees, id: false do |t|
      t.integer :employee_number, null: false, primary_key: true
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :last_name_kana, null: false
      t.string :first_name_kana, null: false
      t.string :hashed_password
      t.string :address, null: false
      t.integer :telephone_number, null: false
      t.string :email, null: false
      t.integer :number_of_paid_leave
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :suspended, null: false, default: false
      t.timestamps
    end

    add_index :employees, "lower(email)", unique: true
    add_index :employees, [ :last_name_kana, :first_name_kana ]
  end
end
