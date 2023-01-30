class Admin::LeaveRequestsController < Admin::Base
  def index
    @leave_requests = LeaveRequest.where(permitted: nil).where(employee_canceled: false)
    @permit_requests = LeaveRequest.where(permitted: true).where(employee_canceled: false)
    @cancel_requests = LeaveRequest.where(employee_canceled: true)
  end

  def show
    #申請が完了したことを確認するためのアクション
    @leave_request = LeaveRequest.find(params[:id])
  end

  def edit
    #新規申請の可否を行うアクション
    @leave_request = LeaveRequest.find(params[:id])
  end

  def update
    #申請の可否の更新（edit -> update用）
    #新規申請と申請取消の更新をひとまとめにすると長くなってしまうので、敢えて別けることにした

    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.update(request_params)

      @employee = Employee.find_by(employee_number: @leave_request.employee_id)

      #申請ステータスが更新された場合の処理

      #有給残り日数を1日減らす
      paid_leave = @employee.number_of_paid_leave.to_i - 1

      if @employee.update_attribute(:number_of_paid_leave, paid_leave)
        #承認後に取り消す場合を考慮して、ここでは申請記録を消去しない
        flash.notice = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を承認しました。"
        redirect_to admin_leave_request_path(@leave_request.id) and return
      end
    else
      flash.now.alert = "お手数ですが、もう一度操作をやり直してください。"
      render action: "edit" and return
    end
  end

  def cancel
    #申請の取消用画面
    @cancel_request = LeaveRequest.find(params[:id])
    unless @cancel_request.employee_canceled
      flash.alert = "まだ従業員からの申請の取消を受け付けていません。"
      redirect_to admin_leave_request_path(@cancel_request.id)
    end
  end

  def cancel_update
    #申請の取消用のアクション（cancel -> cancel_update用）
    @cancel_request = LeaveRequest.find(params[:id])

    if @cancel_request.update(request_params)
      @employee = Employee.find_by(employee_number: @cancel_request.employee_id)

      if @cancel_request.permitted? #管理者側が既に承認している場合の処理
        #有給残り日数を1日増やす
        paid_leave = @employee.number_of_paid_leave + 1
        @employee.update_attribute(:number_of_paid_leave, paid_leave)
      end

      #取り消し後は申請記録を削除
      @cancel_request.destroy
      flash.notice = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を取り消しました。"
      redirect_to admin_leave_requests_path and return

    else
      flash.now.alert = "お手数ですが、もう一度操作をやり直してください。"
      render action: "edit" and return
    end
  end

  private
  def request_params
    params.require(:leave_request).permit(:permitted, :canceled, :reason_for_request)
  end
end
