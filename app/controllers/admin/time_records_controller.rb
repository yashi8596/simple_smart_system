class Admin::TimeRecordsController < Admin::Base
  def index
    @nil_records = Employee.where("tr_judge = ?", false).order(employee_number: :asc)
    @division1 = TimeRecord.where("work_date = ? and division = ?", Date.today, 1).order(division: :asc)
    @division2_3 = TimeRecord.where("work_date = ? and division = ? and division = ?", Date.today, 2, 3).order(division: :asc)
    @division4 = TimeRecord.where("work_date = ? and division = ?", Date.today, 4).order(division: :asc)
  end

  def edit
    @time_record = TimeRecord.find(params[:id])
  end

  def update
    @time_record = TimeRecord.find(params[:id])

    if @time_record.update(tr_params)
      flash.notice = "勤怠記録情報を更新しました。"
      redirect_to admin_time_records_path
    else
      flash.notice = "入力情報に誤りがあります。操作をやり直してください。"
      render action: "edit"
    end
  end

  private
  def tr_params
    params.require(:time_record).permit(:work_date,
    :started_at, :finished_at, :total_time, :absent_time,
    :extra_time, :divison,
    )
  end
end
