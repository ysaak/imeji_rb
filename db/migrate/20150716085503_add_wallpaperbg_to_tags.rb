class AddWallpaperbgToTags < ActiveRecord::Migration
  def change
    change_table :tags do |t|
      t.references :wallpaper
      t.string :bg_x
      t.string :bg_y
    end
  end
end
