class AddEmployeeCanceledToLeaveRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :leave_requests, :employee_canceled, :boolean, null: false, default: false
    remove_column :leave_requests, :reason_for_cancel, :integer
  end
end
