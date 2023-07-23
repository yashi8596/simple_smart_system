class Salary < ApplicationRecord
  belongs_to :employee
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

  def set_wage
    1500
  end

  def set_limit #締め日の設定(ここでは月末とする)
    created_at.end_of_month
  end

  def set_transfer #振込日の設定(ここでは25日とする)
    if set_limit.month == 12
      d = Date.parse("#{set_limit.next_year}/01/25")
    else
      m = set_limit.month + 1
      d = Date.parse("#{set_limit.year}/#{m}/25")
    end

    if d.wday == 6 || d.wday == 0 #25日が休日の場合の処理(祝日は考慮しない)
      date = d.yesterday
      if d.wday == 0 #日曜日は2日戻す
        date = d.yesterday
      end

      return date
    end
  end

  def permit? #給与明細の閲覧の許可判定メソッド(振込日の10日前から可能)
    set_transfer.ago(10.days) <= Date.current
  end
end