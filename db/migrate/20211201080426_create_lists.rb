class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uuid, default: -> { 'md5((random())::text)' }

      t.timestamps
    end
  end
end
