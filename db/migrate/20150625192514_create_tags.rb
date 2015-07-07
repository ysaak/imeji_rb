class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, :null => false
      t.integer :type, :default => 0, :null => false
      t.references :alias_of, index: true
      t.timestamps null: false
    end
  end
end
