class AddAuthenticatedToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :authenticated, :boolean, null: false, default: false
  end
end
