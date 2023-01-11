class Salary < ApplicationRecord
  belongs_to :employee, foreign_key: 'employee_id'


  private
  def calc_basic
    total_hour * wage + (total_minute * wage).floor
  end

  def calc_extra
    ((extra_hour * wage + (extra_minute * wage).floor) * 1.25).floor
  end

  def calc_midnight
    ((midnight_hour * wage + (midnight_minute * wage).floor) * 1.25).floor
  end

  def calc_leave
    8 * wage
  end

  def sum_salary
    calc_basic + calc_extra + calc_midnight + calc_leave
  end
end
