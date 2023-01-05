class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.integer :employee_id, null: false
      t.date :preferred_date, null: false
      t.integer :reason_for_request, null: false, default: 0 #enumを使用
      t.boolean :permitted, null: false, default: true
      t.boolean :canceled, null: false, default: false
      t.integer :reason_for_cancel, default: 0 #enumを使用
      t.timestamps
    end
  end
end
