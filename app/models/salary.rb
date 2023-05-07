class Salary < ApplicationRecord
  belongs_to :employee
  has_many :time_records, dependent: :destroy
  alias_attribute :employee_number, :employee_id

  validates :wage, :total_hour, :extra_hour, :total_minute, :extra_minute, :employee_number, :used_paid_leave, :run_days, :absent_days, presence: true

  def calc_basic
    total_hour * wage + (total_minute * wage).floor
  end

  def calc_extra
    ((extra_hour * wage + (extra_minute * wage).floor) * 1.25).floor
  end

  def calc_leave
    8 * wage * used_paid_leave
  end

  def sum_salary
    calc_basic + calc_extra  + calc_leave
  end
end
