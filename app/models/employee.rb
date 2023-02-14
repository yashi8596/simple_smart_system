class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  has_many :leave_requests, dependent: :destroy

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

  def add_paid_leave
    #有給付与前にgrantedを0に戻す（2回目以降の有給付与で必要なため）
    if next_grant_date <= Date.today && granted?
      self.granted = 0
    end

    #start_dateから1年6ヶ月後(以後1年ごと)に一定の値をnumber_of_paid_leaveに加算する
    if !granted? && next_grant_date <= Date.today
      case next_grant_date
      when start_date.since(6.month) then
      #6ヶ月後の有給付与
        self.number_of_paid_leave = 10
      when start_date.since(18.month) then
      #1年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 11
      when start_date.since(30.month) then
      #2年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 12
      when start_date.since(42.month) then
      #3年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 14
      when start_date.since(54.month) then
      #4年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 16
      when start_date.since(66.month) then
      #5年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 18
      when start_date.since(78.month)..nil then
      #6年6ヶ月後の有給付与
        self.number_of_paid_leave = number_of_paid_leave.to_i + 20
      end
      self.granted = 1 #before_actionで実行するので、ログインする度に有給が付与されないようにする
      self.prev_grant_date = next_grant_date #next_grant_dateをprev_grant_dateに代入
      self.next_grant_date = next_grant_date.since(1.year) #next_grant_dateに既定値の1年後の日付を代入
    end
  end

  def active?
    !suspended?  && start_date <= Date.today && (end_date.nil?  || end_date > Date.today)
  end
end
