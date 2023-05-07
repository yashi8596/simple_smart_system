class TimeRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :salary
  alias_attribute :employee_number, :employee_id

  enum division: {出勤: 1, 有給: 2, 欠勤: 3, 休日出勤: 4 } #記録の管理区分

  #出勤時間と退勤時間を計算するための定数を設定

  #例えば始業時間が6:30の場合、「6.0 * 60.0 + 30.0 」のように計算する（退勤も同様）
  STARTMINUTES = 8.0 * 60.0 + 0.0
  FINISHMINUTES = 17.0 * 60.0 + 0.0

  #休憩時間
  BREAK1 = 60.0 #12:00から13:00までの休憩
  BREAK2 = 15.0 #17:00から17:15までの休憩
  BREAK3 = 15.0 #19:00から19:15までの休憩


  def late_calc #遅刻時間の計算
    late = s_time_calc - STARTMINUTES
    if late > 0.0
      late
    else
      0.0
    end
  end

  def late_early_calc #遅刻・早退の計算
    if finished_at == nil
      late_calc / 60.0
    else
      (late_calc + early_calc) / 60.0
    end
  end

  def early_calc #早退時間の計算
     early = FINISHMINUTES - f_time_calc
    if early > 0.0
      early
    else
      0.0
    end
  end

  def time_calc #就業時間の計算
    tt = f_time_calc - s_time_calc - BREAK1

    if f_time_calc >= 17.0 * 60.0 + BREAK2
      tt -= BREAK2
    end

    if f_time_calc >= 19.0 * 60.0 + BREAK3 #19:15以降の計算
      tt -= BREAK3
    end

    tt / 60.0
  end

  def ex_time_calc #残業時間の計算
    if time_calc > 8.0
      time_calc - 8.0
    else
      0.0
    end
  end



  def s_time_calc #計算用に打刻時間を変換(f_time_calcも同様)
    s_time = (started_at.hour * 60) + started_at.min
    if s_time < STARTMINUTES
      STARTMINUTES
    else
      s_min = s_time.div(60) #15分切り上げして計算
      s_time = (started_at.hour * 60).to_f
      if s_min <= 15 && s_min >= 1
        s_time + 15.0
      elsif s_min <= 30
        s_time + 30.0
      elsif s_min <= 45
        s_time + 45.0
      elsif s_min <= 59 && s_min == 0
        s_time + 60.0
      end
    end
  end

  def f_time_calc
    f_min = finished_at.min.div(15) #15分切り捨てして計算
    f_time = (finished_at.hour * 60.0).to_f
    if f_min == 0
      f_time
    elsif f_min == 1
      f_time + 15.0
    elsif f_min == 2
      f_time + 30.0
    elsif f_min == 3
      f_time + 45.0
    end
  end

  def time_split
    tt_h, tt_m = total_time.to_s.split(".")
    tt_h.to_i
    tt_m = tt_m.to_f / 100.0

    if extra_time
      et_h, et_m = extra_time.to_s.split(".")
      et_h.to_i
      et_m = et_m.to_f / 100.0
    else
      et_h, et_m = 0, 0.0
    end

    if absent_time
      at_h, at_m = absent_time.to_s.split(".")
      at_h.to_i
      at_m = at_m.to_f / 100.0
    else
      at_h, at_m = 0, 0.0
    end

    return tt_h, tt_m, et_h, et_m, at_h, at_m
  end
end
