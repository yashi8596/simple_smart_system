class TimeRecord < ApplicationRecord
  belongs_to :employee
  alias_attribute :employee_number, :employee_id


  STARTMINUTES = 8 * 60
  FINISHMINUTES = 17 * 60
  BREAK1 = 60
  BREAK2 = 10
  BREAK3 = 15


  def late_calc
    s_time_calc.to_i - STARTMINUTES
  end

  def late_early_calc
    if finished_at == nil
      (late_calc / 60).floor
    else
      ((late_calc + early_calc) / 60).floor
    end
  end

  def early_calc
    FINISHMINUTES - f_time_calc.to_i
  end

  def time_calc
    ((f_time_calc - s_time_calc - BREAK1 ) / 60).floor
  end

  def ex_time_calc
    if (time_calc * 60) >= (480 + 25)
      ex_min = f_time_calc - FINISHMINUTES - BREAK2 - late_calc
      if finished_at.hour >= 19
        ex_min = ex_min - BREAK3
      end
      (ex_min / 60).floor
    else
      0
    end
  end

  private

  def s_time_calc
    s_time = (started_at.hour * 60) + started_at.min
    if s_time < STARTMINUTES
      STARTMINUTES
    else
      s_min = 15.div(started_at.min)
      if s_min == 0
        started_at.hour * 60 + 15
      elsif s_min == 1
        started_at.hour * 60 + 30
      elsif s_min == 2
        started_at.hour * 60 + 45
      elsif s_min == 3
        started_at.hour * 60 + 60
      end
    end
  end

  def f_time_calc
    f_min = 15.div(finished_at.min)
    if f_min == 0
      finished_at.hour * 60
    elsif f_min == 1
      finished_at.hour * 60 + 15
    elsif f_min == 2
      finished_at.hour * 60 + 30
    elsif f_min == 3
      finished_at.hour * 60 + 45
    end
  end
end
