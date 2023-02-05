class LeaveRequest < ApplicationRecord
  belongs_to :employee

  validates :preferred_date, :reason_for_request, presence: true
  def emp_request
    #申請(取消も含む)可能かどうかの判定メソッド（取得予定日時の10日前まで(従業員用)）
    preferred_date.ago(10.days) >= Date.current
  end

  def ad_request
    #申請(取消も含む)可能かどうかの判定メソッド（取得予定日時の7日前まで(管理者用)）
    preferred_date.ago(7.days) >= Date.current
  end

  def auto_destroy
    #有給の自動削除判定メソッド
    preferred_date <= Date.today
  end
end