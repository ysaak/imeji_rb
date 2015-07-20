class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters, :id => false do |t|
      t.string :name, :null => false
      t.string :value, :null => false
    end

    add_index :parameters, :name, :unique => true
  end
end
