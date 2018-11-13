class Tag < ApplicationRecord
  has_and_belongs_to_many :documents

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  validate :format_name

  def format_name
    if name.match?(/\s/) || name.include?("+") || name.include?("-")
      errors.add(:name, "please enter tags in correct format, without -, + or whitespaces")
    end
  end
end
