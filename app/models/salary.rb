class Salary < ApplicationRecord
  belongs_to :employee, foreign_key: 'employee_number', primary_key: 'employee_number'
end
