class AlterEmployees1 < ActiveRecord::Migration[6.1]
  def change
    add_index :employees, :first_name_kana
    add_index :employees, :employee_number
    add_index :employees, [ :employee_number, :last_name_kana, :first_name_kana ], name: "index_emoloyees_on_employee_number_and_furigana"
  end
end
