class Document < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :name, :uuid, presence: true

  before_validation :generate_uuid

  scope :by_tags, -> (search, offset) {
    # ToDO: Implement offset
    tags = self.map_tags(search)
    files_in = Document.joins(:tags).where("tags.name IN (?)", tags.first).distinct
    files_out = Document.joins(:tags).where("tags.name IN (?)", tags.second).distinct
    (files_in - files_out)
  }

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

  def records
    {
      uuid: uuid,
      name: name
    }
  end

  def related_tags
    res = []
    res << tags.map { |tag| { name: tag.name, counter: tag.documents.count } }
  end

  def self.map_tags(search)
    tags = search.split(' ')
    tags_in = []
    tags_out = []

    tags.each do |tag|
      if tag.chars.first == '+'
        tags_in << tag[1..-1]
      else
        tags_out << tag[1..-1]
      end
    end
    [tags_in, tags_out]
  end
end
