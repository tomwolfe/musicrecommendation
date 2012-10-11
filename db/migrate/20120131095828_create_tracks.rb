class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string  :name
      t.string  :artist_name
      t.float   :average_rating

      t.timestamps
    end
  end
end
