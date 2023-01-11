class EmployeeEvent < ApplicationRecord
  self.inheritance_column = nil
  
  belongs_to :employee, foreign_key: :employee_id
  alias_attribute :occurred_at, :created_at
end
