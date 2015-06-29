class CreateTagsWallpapers < ActiveRecord::Migration
  def change
    create_table :tags_wallpapers do |t|
      t.integer :tag_id,  :null => false, :index => true
      t.integer :wallpaper_id,  :null => false, :index => true
    end
  end
end
