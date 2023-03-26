class Admin::EmployeeSearchForm
  include ActiveModel::Model
  include StringNormalizer

  attr_accessor :last_name_kana, :first_name_kana, :employee_number

  def search
    normalize_values

    rel = Employee

    if last_name_kana.present? || first_name_kana.present? || employee_number.present?
      rel = rel.where(last_name_kana: last_name_kana).or(rel.where(first_name_kana: first_name_kana).or(rel.where(employee_number: employee_number)))
    end

    rel.order(employee_number: :asc)
  end

  private
  def normalize_values
    self.last_name_kana = normalize_as_furigana(last_name_kana)
    self.first_name_kana = normalize_as_furigana(first_name_kana)
    self.employee_number = normalize_as_employee_number(employee_number).try(:gsub, /\D/, "")
  end
end