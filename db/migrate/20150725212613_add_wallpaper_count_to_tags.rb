class AddWallpaperCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :wallpapers_count, :integer, default: 0, :null => false
  end
end
