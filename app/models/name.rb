class Name < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :list

  validates :title, uniqueness: { scope: %i[title list_id] }
  validates :title, presence: true
  validates :list, presence: true
  validate :name_and_list_id_uniqueness

  before_save :clean_data
  scope :by_keywords, ->(keywords) { where('names.title ILIKE :title', title: "%#{keywords}%") }

  def clean_data
    title.strip
  end

  def name_and_list_id_uniqueness
    results = Name.find_by(title: title, list_id: list_id)
    errors.add(:name_uniquenss, 'unique name is required per list') if results
  end
end
