class CreateTagsWallpapers < ActiveRecord::Migration
  def change
    create_join_table :tags, :wallpapers do |t|
      t.index :tag_id
      t.index :wallpaper_id
    end
  end
end
