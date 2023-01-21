class Public::LeaveRequestsController < Public::Base
  def new
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = LeaveRequest.new(lr_params)
    if @leave_request.save
      flash.notice = "有給申請を受け付けました。"
      redirect_to root_path(current_employee)
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

  def cancel_update
    @cancel_request = LeaveRequest.find(params[:id])
    if @cancel_request.update(cr_params)
      flash.notice = "有給申請の取消を受け付けました。"
      redirect_to leave_request_path(@cancel_request.id)
    else
      flash.now.alert = "お手数ですが、操作をやり直して下さい。"
      render action: "cancel"
    end
  end

  private
  def lr_params
    params.require(:leave_request).permit(:employee_number, :preferred_date, :reason_for_request)
  end

  def cr_params
    params.require(:leave_request).permit(:employee_canceled)
  end
end
