class AddListToNames < ActiveRecord::Migration[6.0]
  def change
    add_reference :names, :list, null: false, foreign_key: true
    add_index :names, %i[list_id title], unique: true
  end
end
