class Public::LeaveRequestsController < Public::Base
  def new
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = LeaveRequest.new(lr_params)
    if @leave_request.save
      flash.notice = "有給申請を送信しました。"
      redirect_to leave_request_path(@leave_request.id)
    else
      flash.now.alert = "入力項目に誤りがあります。"
      render action: "new"
    end
  end

  def show
    @leave_request = LeaveRequest.find_by(employee_number: current_employee.employee_number, id: params[:id])
  end

  def cancel
    @cancel_request = LeaveRequest.find_by(employee_number: current_employee.employee_number, id: params[:id])
  end

  private
  def lr_params
    params.require(:leave_request).permit(:employee_number, :preferred_date, :reason_for_request)
  end
end
