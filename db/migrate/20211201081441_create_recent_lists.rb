class CreateRecentLists < ActiveRecord::Migration[6.0]
  def change
    create_table :recent_lists do |t|
      t.references :list, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.index %i[user_id list_id], unique: true
    end
  end
end
