class CreateTagImplication < ActiveRecord::Migration
  def change
    create_table :tag_implications do |t|
      t.references :tag, index: true, null: false
      t.references :implied_tag, index: true, null: false
    end
  end
end
