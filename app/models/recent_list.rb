class RecentList < ApplicationRecord
    belongs_to :user
    belongs_to :list
    # validates :user, presence: true
    # validates :list, presence: true
    # validates :user_id_and_list_id_uniqueness

    private

    # def user_id_and_list_id_uniqueness
    #     results = RecentList.find_by(user_id: self.user_id, list_id: self.list_id)
    #     errors.add(:name_uniquenss, "One user has only recently viewed list") if results
    # end
end