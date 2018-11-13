class Document < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :name, :uuid, presence: true

  before_validation :generate_uuid

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def assign_tags(tags)
    tags.map do |tag|
      record_tag = Tag.find_or_create_by(name: tag)

      if record_tag.valid?
        self.tags << record_tag
      end
    end
  end
end
