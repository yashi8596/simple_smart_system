require "nkf"

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize_as_name(text)
    NKF.nkf("-W -w -Z1", text).strip if text
  end

  def normalize_as_furigana(text)
    NKF.nkf("-W -w -Z1 --katakana", text).strip if text
  end

  def normalize_as_employee_number(text)
    NKF.nkf("-W -w -Z1", text).strip.gsub(/D/, "") if text
  end
end