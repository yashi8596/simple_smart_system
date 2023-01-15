class Admin::LeaveRequestsController < Admin::Base
  def index
    @leave_requests = LeaveRequest.where(permitted: false).where(employee_canceled: false)
    @cancel_requests = LeaveRequest.where(employee_canceled: true)
  end

  def show
    @leave_request = LeaveRequest.find(params[:id])
  end

  def update
    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.update(request_params)

      if @leave_request.permitted == true
        #申請ステータスが更新された場合の処理
        #eventテーブルに記録
        event = EmployeeEvent.new
        event.employee_id = @leave_request.employee_number
        event.paid_leave_date = @leave_request.preferred_date
        event.type = "有給"
        event.save(save_params)

        #有給残り日数を1日減らす
        @employee = Employee.find(@event.employee_id)
        paid_leave = @employee.number_of_paid_leave - 1

        if event.save && @employee.update_attribute(:number_of_paid_leave, paid_leave)
          #承認後に取り消す場合を考慮して、@requestは消去しない
          flash.notice = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を承認しました。"
          redirect_to admin_leave_request_path(@leave_request.id) and return
        end

      elsif @leave_request.canceled == true
        #取消ステータスが更新された場合の処理
        #eventsテーブルから該当データを探す
        event = EmployeeEvent.find_by(employee_id: @leave_request.employee_number)

        if event.present?
          #有給残り日数を1日増やす
          @employee = Employee.find(event.employee_id)
          paid_leave = @employee.number_of_paid_leave + 1

          #eventレコードを削除
          event.destroy
          if @employee.update_attribute(:number_of_paid_leave, paid_leave)
            #取り消し後はrequestレコードを削除
            @leave_request.destroy
            flash.notice = "#{@employee.last_name}#{@employee.first_name}さんの有給申請を取り消しました。"
            redirect_to admin_leave_requests_path and return
          end
        end
      end
    end

    flash.now.alert = "お手数ですが、もう一度操作をやり直してください。"
    render action: "edit" and return
  end

  private
  def request_params
    params.require(:leave_requests).permit(:permitted, :canceled)
  end

  def save_params
    params.require(:employee_events).permit(:employee_id, :type, :paid_leave)
  end
end
