class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :names, dependent: :destroy

  after_create :create_default_list

  has_one :list

  has_one :recent_list

  def create_default_list
    list = List.create(user_id: self.id)
    RecentList.create(user_id: self.id, list_id: list.id) 
  end
end
