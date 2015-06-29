class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.string :filehash
      t.string :ext
      t.integer :size
      t.integer :width
      t.integer :height
      t.string :category
      t.string :purity

      t.timestamps
    end
  end
end
