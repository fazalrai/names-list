class Name < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :list

  validates :title, uniqueness: { scope: [:list_id] }
  validates :title, presence: true

  before_save :clean_data

  scope :search, ->(term) { where('names.title ILIKE :title', title: "%#{term}%") }

  def clean_data
    title.strip
  end
end
