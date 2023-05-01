class Public::TimeRecordsController < ApplicationController

  def index
    @today_record = TimeRecord.find_by(employee_id: current_employee.id, created_at: Date.today)
    @current_month = Date.current.all_month
    @time_records = TimeRecord.where(employee_id: current_employee.id, created_at: Date.current.all_month)

  end

  def create
    @today_record = TimeRecord.create(employee_id: params[:employee_id], started_at: params[:started_at])
    if @today_record.create?
      flash.notice = "おはようございます。出勤打刻を受け付けました。"
      redirect_to time_record_path(@today_record.id)
    else
      flash.now.alert = "操作を完了できませんでした。もう一度やり直してください。"
      render action: "index"
    end
  end

  def show
    @time_record = TimeRecord.find_by(employee_id: current_employee.id, id: params[:id])
  end

  def update
    @today_record = TimeRecord.find_by(employee_id: current_employee.id, created_at: Date.today)
    if @today_record.update(:finished_at, params[:finished_at])
      flash.notice = "退勤打刻を受け付けました。お疲れさまでした。"
      redirect_to time_record_path(@today_record.id)
    else
      flash.now.alert = "操作を完了できませんでした。もう一度やり直してください。"
      render action: "index"
    end
  end
end
