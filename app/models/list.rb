class List < ApplicationRecord
  belongs_to :user

  has_one :recent_list
  has_many :names

  validates :user, presence: true, uniqueness: true
end
