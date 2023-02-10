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

  def active?
    !suspended?  && start_date <= Date.today && (end_date.nil?  || end_date > Date.today)
  end
end
