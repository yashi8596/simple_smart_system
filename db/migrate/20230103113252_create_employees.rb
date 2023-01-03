class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.integer :employee_number, null: false #従業員番号
      t.string :last_name, null: false #姓
      t.string :first_name, null: false #名
      t.string :last_name_kana, null: false #姓（カナ）
      t.string :first_name_kana, null: false #名（カナ）
      t.string :hashed_password, null: false #ログイン用パスワード
      t.string :address, null: false #住所
      t.integer :telephone_number, null: false #電話番号
      t.string :email, null: false #Eメールアドレス(パスワード再設定用)
      t.integer :number_of_paid_leave, null: false, default: 0 #有給休暇残り日数
      t.date :start_date, null: false #就業開始日（開始日からログイン可能）
      t.date :end_date #就業終了日（以降ログイン不可）
      t.boolean :suspended, null: false, default: false #無効フラグ（一時的にアカウントを使用できなくする）
      t.timestamps
    end

    add_index :employees, "lower(email)", unique: true
    add_index :employees, :employee_number, unique: true
    add_index :employees, [ :last_name_kana, :first_name_kana ]
  end
end
