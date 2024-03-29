class CreateLeaveRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :leave_requests do |t|
      t.string :employee_id, null: false
      t.date :preferred_date, null: false
      t.text :reason_for_request, null: false
      t.boolean :permitted
      t.boolean :canceled, null: false, default: false
      t.boolean :employee_canceled, default: false, null: false
      t.timestamps
    end
  end
end