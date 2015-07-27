class RenamePurityToRatingInWallpapers < ActiveRecord::Migration
  def change
    rename_column :wallpapers, :purity, :rating
  end
end
