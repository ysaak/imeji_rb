class RemoveCategoryFromWallpapers < ActiveRecord::Migration
  def change
    remove_column :wallpapers, :category
  end
end
