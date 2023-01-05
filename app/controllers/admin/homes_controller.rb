class Admin::HomesController < Admin::Base
  def top
    @employees = Employee.order(:last_name_kana, :first_name_kana)
  end
end
