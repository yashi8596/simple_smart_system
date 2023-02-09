class Public::LeaveRequestsController < Public::Base
  def new
    unless current_employee.number_of_paid_leave?
      flash.alert = "有給残日数が「0日」のため、申請を行うことができません。"
      redirect_to root_path(current_employee)
    else
      @leave_request = LeaveRequest.new
    end
  end

  def create
    @leave_request = LeaveRequest.new(lr_params)
    if @leave_request.emp_request
      if @leave_request.save
        flash.notice = "有給申請を受け付けました。（申請取り消しはトップページ下に表示されています。）"
        redirect_to root_path(current_employee) and return
      else
        flash.now.alert = "入力項目に誤りがあります。"
      end
    else
      flash.now.alert = "期日を過ぎているため、申請を受け付けることができません。申請期日は取得予定日から10日前までとなります。"
    end
    render action: "new" and return
  end

  def show
    @leave_request = LeaveRequest.find_by(employee_id: current_employee.id, id: params[:id])
  end

  def cancel
    @cancel_request = LeaveRequest.find_by(employee_id: current_employee.id, id: params[:id])
    unless @cancel_request.permitted?
      flash.alert = "管理者が申請を承認していないため、取消を受け付けることができません。"
      redirect_to root_path(current_employee)
    end
  end

  def cancel_update
    @cancel_request = LeaveRequest.find(params[:id])
    if @cancel_request.emp_request

      if @cancel_request.update(cr_params)
        flash.notice = "有給申請の取消を受け付けました。"
        redirect_to leave_request_path(@cancel_request.id)
      else
        flash.now.alert = "お手数ですが、操作をやり直して下さい。"
        render action: "cancel"
      end
    else
      flash.alert = "期日を過ぎているため、取消申請を受け付けることができません。申請期日は取得予定日から10日前までとなります。"
      redirect_to root_path(current_employee)
    end
  end

  private
  def lr_params
    params.require(:leave_request).permit(:employee_id, :preferred_date, :reason_for_request)
  end

  def cr_params
    params.require(:leave_request).permit(:employee_canceled)
  end
end
