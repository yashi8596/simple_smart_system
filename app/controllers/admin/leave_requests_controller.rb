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

      @employee = Employee.find_by(employee_number: @leave_request.employee_number)

      if @leave_request.permitted?

        #申請ステータスが更新された場合の処理
        #eventテーブルに記録
        event = EmployeeEvent.new
        event.employee_id = @leave_request.employee_number
        event.paid_leave_date = @leave_request.preferred_date
        event.type = "有給"
        event.created_at = Time.current
        event.save

        #有給残り日数を1日減らす
        paid_leave = @employee.number_of_paid_leave.to_i - 1

        if event.save && @employee.update_attribute(:number_of_paid_leave, paid_leave)
          #承認後に取り消す場合を考慮して、ここでは申請記録を消去しない
          flash.notice = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を承認しました。"
          redirect_to admin_leave_request_path(@leave_request.id) and return
        end

      else

        flash.alert = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を拒否しました。"
        redirect_to admin_leave_request_path(@leave_request.id) and return
      end
    else
      flash.now.alert = "お手数ですが、もう一度操作をやり直してください。"
      render action: "edit" and return
    end
  end

  def cancel
    #申請の取消用画面
    @leave_request = LeaveRequest.find(params[:id])
  end

  def cancel_update
    #申請の取消用のアクション（cancel -> cancel_update用）
    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.update(request_params)

      @employee = Employee.find_by(employee_number: @leave_request.employee_number)

      if @leave_request.permitted? #管理者側が既に承認している場合の処理

        #eventsテーブルから該当データを探す
        event = EmployeeEvent.find_by(employee_id: @leave_request.employee_number, paid_leave_date: @leave_request.preferred_date)

        #有給残り日数を1日増やす
        paid_leave = @employee.number_of_paid_leave + 1

        #eventレコードを削除
        event.destroy
        @employee.update_attribute(:number_of_paid_leave, paid_leave)
      end

      #取り消し後はrequestレコードを削除
      @leave_request.destroy
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
