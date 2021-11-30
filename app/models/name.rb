class Name < ApplicationRecord
  default_scope { order(created_at: :desc) }
  

  belongs_to :user
  validates_uniqueness_of :title
  scope :by_keywords, lambda { |keywords| where("names.title ILIKE :title", title: "%#{keywords}%") }
  validates :title, presence: true
  before_save :clean_data

  def clean_data
    self.title.strip
  end
end
