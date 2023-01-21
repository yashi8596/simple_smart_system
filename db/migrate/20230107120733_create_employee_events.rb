class CreateEmployeeEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :employee_events do |t|
      # 従業員のログイン・ログアウト記録、有給記録用テーブル
      # このテーブルはレコードの更新はしないので、timestampは使わない
      t.integer :employee_id, null: false
      t.string :type, null: false #従業員の記録を区別させるカラム
      t.date :paid_leave_date #有給使用日をカレンダーに反映させるためのカラム
      t.datetime :created_at, null: false
    end

    add_index :employee_events, :created_at
    add_index :employee_events, [ :employee_id, :created_at ]
  end
end
