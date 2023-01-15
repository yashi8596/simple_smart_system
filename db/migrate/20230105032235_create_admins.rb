class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.integer :employee_number, null: false
      t.string :hashed_password, null: false
      t.string :email, null: false
      t.boolean :suspended, null: false, default: false
      t.timestamps
    end

    add_index :admins, "LOWER(email)", unique: true

  end
end
