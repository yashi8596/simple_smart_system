class TimeRecord < ApplicationRecord
  belongs_to :employee
  
  STARTHOUR = 8
  FINISHHOUR = 17
  BREAK1 = 60
  BREAK2 = 10
  BREAK3 = 15
  def s_time_calc
    if started_at.hour < STARTHOUR
      STARTHOUR * 60
    else
      s_min = 15.div(started_at.min)
      if s_min == 0
        started_at.hour * 60 + 15
      elsif s_min == 1
        started_at.hour * 60 + 30
      elsif s_min == 2
        started_at.hourR * 60 + 45
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
  
  def time_calc
    ((f_time_calc - s_time_calc - BREAK1 ) / 60).floor
  end
  
  def ex_time_calc
    if f_time_calc > (FINISHHOUR * 60)
      ex_min = f_time_calc - (FINISHHOUR * 60) - BREAK2
      if finished_at.hour >= 19
        ex_min = ex_min - BREAK3
      end
      (ex_min / 60).floor
    end
  end
  
end
