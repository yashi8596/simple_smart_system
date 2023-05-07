class Public::TimeRecordsController < Public::Base

  def index
    @today_record = TimeRecord.find_by(employee_number: current_employee.id, work_date: Date.today)
    @time_records = TimeRecord.where(employee_number: current_employee.id, work_date: Date.current.all_month)

  end

  def create
    @today_record = TimeRecord.create(employee_number: current_employee.id, started_at: Time.new)

    @today_record.work_date = @today_record.created_at

    if @today_record.late_calc > 0
      @today_record.absent_time = @today_record.late_early_calc
    end

    #休日出勤の判定(祝日は考慮しない)
    day = @today_record.work_date.wday
    if (day == 0) || (day == 6)
      @today_record.division = 4
    end

    #勤怠状況が分からない従業員を判別するためにtr_judgeを更新する
    judge = Employee.find_by(employee_number: current_employee.id)
    judge.tr_judge = true
    judge.tr_date = Time.new

    if @today_record.save && judge.save
      flash.notice = "おはようございます。出勤打刻を受け付けました。"
      redirect_to time_records_path

    else
      @today_record = TimeRecord.find_by(employee_number: current_employee.id, work_date: Date.today)
      @time_records = TimeRecord.where(employee_number: current_employee.id, work_date: Date.current.all_month)

      flash.now.alert = "操作を完了できませんでした。もう一度やり直してください。"
      render action: "index"
    end
  end

  def update
    @today_record = TimeRecord.find_by(employee_number: current_employee.id, work_date: Date.today)

    @today_record.finished_at = Time.new
    @today_record.time_calc

    @today_record.total_time = @today_record.time_calc

    #早退時の時間処理
    if @today_record.early_calc > 0
      @today_record.absent_time = @today_record.late_early_calc

    else
      @today_record.extra_time = @today_record.ex_time_calc
    end

    if @today_record.division == "休日出勤"
      #休日出勤時の時間処理
      @today_record.extra_time = @today_record.total_time
    end

    if @today_record.update(tr_params)

      salary = Salary.find_by(employee_number: current_employee_id, created_at: Time.current.all_month)

      unless salary
        salary = current_employee.salaries.new
      end

      tt_h, tt_m, et_h, et_m, at_h, at_m = @today_record.time_split

      salary.total_hour += tth
      salary.total_minute += ttm
      salary.extra_hour += et_h
      salary.extra_minute += et_m
      salary.absent_hour += at_h
      salary.absent_minute += at_m

      if salary.save
        flash.notice = "退勤打刻を受け付けました。お疲れさまでした。"
        redirect_to time_records_path
      end
    end

    @today_record = TimeRecord.find_by(employee_number: current_employee.id, work_date: Date.today)
    @time_records = TimeRecord.where(employee_number: current_employee.id, work_date: Date.current.all_month)

    flash.now.alert = "操作を完了できませんでした。もう一度やり直してください。"
    render action: "index"
  end

  private

  def tr_params
    params.permit(:finished_at, :total_time, :absent_time, :extra_time)
  end
end
