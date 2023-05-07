class Admin::TimeRecordsController < Admin::Base
  def index
    @nil_records = Employee.where("tr_judge = ?", false).order(employee_number: :asc)
    @division1 = TimeRecord.where("work_date = ? and division = ?", Date.today, 1).order(division: :asc)
    @division2_3 = TimeRecord.where("work_date = ? and division = ? and division = ?", Date.today, 2, 3).order(division: :asc)
    @division4 = TimeRecord.where("work_date = ? and division = ?", Date.today, 4).order(division: :asc)
  end

  def edit
  end

  def update
  end
end
