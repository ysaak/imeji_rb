class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :red
      t.string :green
      t.string :blue
      t.float :percent
      t.references :wallpaper, index: true

      t.timestamps
    end
  end
end
