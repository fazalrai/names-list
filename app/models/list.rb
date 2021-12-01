class List < ApplicationRecord
  belongs_to :user
  has_many :names

  validates :user, presence: true, uniqueness: true
end
