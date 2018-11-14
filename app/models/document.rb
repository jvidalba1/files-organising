class Document < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :name, :uuid, presence: true

  before_validation :generate_uuid

  def self.response(search, offset)
    tags = self.map_tags(search)

    tags_in = self.get_tags(tags.first)
    tags_out = self.get_tags(tags.second)

    files_in = self.get_documents(tags_in)
    files_out = self.get_documents(tags_out)

    # files_out = Document.joins(:tags).where("tags.name IN (?)", tags.second).distinct

    files = self.diff_set(files_in, files_out)
    related_tags = self.related_tags(files, tags_in)

    { documents: files, related_tags: related_tags }
  end

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

  private

    def self.related_tags(files, tags_in)
      all_tags = files.map { |file| file.tags }.flatten.uniq
      self.diff_set(all_tags, tags_in)
    end

    def self.get_documents(tags)
      where("id in (?)", self.query_execution(self.aggregation_query(tags)))
    end

    def self.aggregation_query(tags)
      "select document_id
      from documents_tags
      group by document_id
      having array_agg(tag_id::integer) @> array#{tags.map(&:id)};"
    end

    def self.query_execution(query)
      ActiveRecord::Base.connection.execute(query).values.flatten
    end

    def self.get_tags(tags)
      Tag.where("name IN (?)", tags)
    end

    def self.diff_set(_in, _out)
      (_in - _out)
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
