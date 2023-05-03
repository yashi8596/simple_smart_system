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

    if @today_record.save
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

    if @today_record.early_calc > 0
      @today_record.absent_time = @today_record.late_early_calc
    else
      @today_record.extra_time = @today_record.ex_time_calc
    end

    if @today_record.update(tr_params)
      flash.notice = "退勤打刻を受け付けました。お疲れさまでした。"
      redirect_to time_records_path
    else
      @today_record = TimeRecord.find_by(employee_number: current_employee.id, work_date: Date.today)
      @time_records = TimeRecord.where(employee_number: current_employee.id, work_date: Date.current.all_month)

      flash.now.alert = "操作を完了できませんでした。もう一度やり直してください。"
      render action: "index"
    end
  end

  private

  def tr_params
    params.permit(:finished_at, :total_time, :absent_time, :extra_time)
  end
end
