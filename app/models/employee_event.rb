class EmployeeEvent < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :employee
  alias_attribute :occurred_at, :created_at
end
