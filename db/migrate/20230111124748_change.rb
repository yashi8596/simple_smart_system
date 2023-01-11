class Change < ActiveRecord::Migration[6.1]
  def change
    change_column :leave_requests, :reason_for_request, :text
  end
end
