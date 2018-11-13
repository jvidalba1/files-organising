class Document < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :name, :uuid, presence: true

  before_validation :generate_uuid

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
