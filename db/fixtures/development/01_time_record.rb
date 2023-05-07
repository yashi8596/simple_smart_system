TimeRecord.seed do |s|
  s.id = 1
  s.employee_id = "0000001"
  s.work_date = Date.new(2023, 5, 5)
  s.started_at = DateTime.new(2023, 5, 4, 22, 43, 0)
  s.finished_at = DateTime.new(2023, 5, 5, 11, 32, 0)
  s.total_time = 11.0
  s.absent_time = 0.0
  s.extra_time = 3.0
  s.division = 1
end