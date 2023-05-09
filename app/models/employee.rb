class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :time_records, dependent: :destroy

  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/

  validates :last_name, :first_name, :email, :address, :telephone_number, presence: true
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: KATAKANA_REGEXP, allow_blank: true }
  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1),
    before: -> (obj) { 1.year.from_now.to_date },
    allow_blank: true
  }
  validates :end_date, date: {
    after: :start_date,
    before: -> (obj) { 1.year.from_now.to_date },
    allow_blank: true
  }

  def password=(raw_password)
    #登録時に入力された平文のパスワードをハッシュ化してhashed_passwordカラムにセットする
    if raw_password.kind_of?(String)

      self.hashed_password = BCrypt::Password.create(raw_password)

    elsif raw_password.nil?

      self.hashed_password = nil

    end
  end

  def active?
    !suspended?  && start_date <= Date.today && (end_date.nil?  || end_date > Date.today)
  end

  def granted_reset
    next_grant_date <= Date.today && granted?
  end

  def add_granted?
    !granted? && next_grant_date <= Date.today
  end

  def calc_paid_leave
    if next_grant_date == (start_date >> 6)
    #6ヶ月後の有給付与
      number_of_paid_leave.to_i + 10

    elsif next_grant_date == (start_date >> 18)
    #1年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 11

    elsif next_grant_date == (start_date >> 30)
    #2年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 12

    elsif next_grant_date == (start_date >> 42)
    #3年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 14

    elsif next_grant_date == (start_date >> 54)
    #4年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 16

    elsif next_grant_date == (start_date >> 66)
    #5年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 18

    elsif next_grant_date == (start_date >> 78..nil)
    #6年6ヶ月後の有給付与
      number_of_paid_leave.to_i + 20
    end
  end

  def employee_display
    employee_number + '  ' + last_name + '' + first_name
  end

  def tr_judge_reset #日付変更(day)によるtr_judgeのリセット
    if (tr_date.year != Date.today.year) || (tr_date.month != Date.today.month) || (tr_date.day != Date.today.day)
      0
    end
  end

  def sly_judge_reset #日付変更(month)によるsly_judgeのリセット
    if sly_date.month != Date.today.month
      0
    end
  end
end
