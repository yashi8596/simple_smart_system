class Requests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.date :preferred_date, null: false
      t.integer :reason_for_request, default: 0, null: false
      t.boolean :permitted, default: true, null: false
      t.boolean :canceled, default: false, null: false
      t.integer :reason_for_cancel, default: 0
      t.integer :employee_number, null: false
      t.timestamps
    end
  end
end
