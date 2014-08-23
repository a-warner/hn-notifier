class CreateSavedSearches < ActiveRecord::Migration
  def change
    create_table :saved_searches do |t|
      t.belongs_to :user, null: false
      t.string :query, null: false

      t.timestamps
    end
  end
end
