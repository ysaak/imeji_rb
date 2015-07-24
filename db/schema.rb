# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150724151943) do

  create_table "colors", force: true do |t|
    t.string   "red"
    t.string   "green"
    t.string   "blue"
    t.float    "percent",      limit: 24
    t.integer  "wallpaper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colors", ["wallpaper_id"], name: "index_colors_on_wallpaper_id", using: :btree

  create_table "groups", force: true do |t|
    t.string  "name",      null: false
    t.integer "parent_id"
  end

  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree

  create_table "parameters", id: false, force: true do |t|
    t.string "name",  null: false
    t.string "value", null: false
  end

  add_index "parameters", ["name"], name: "index_parameters_on_name", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",                     null: false
    t.integer  "alias_of_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "wallpaper_id"
    t.string   "bg_x"
    t.string   "bg_y"
    t.integer  "group_id",     default: 1, null: false
  end

  add_index "tags", ["alias_of_id"], name: "index_tags_on_alias_of_id", using: :btree
  add_index "tags", ["group_id"], name: "index_tags_on_group_id", using: :btree

  create_table "tags_wallpapers", id: false, force: true do |t|
    t.integer "tag_id",       null: false
    t.integer "wallpaper_id", null: false
  end

  add_index "tags_wallpapers", ["tag_id"], name: "index_tags_wallpapers_on_tag_id", using: :btree
  add_index "tags_wallpapers", ["wallpaper_id"], name: "index_tags_wallpapers_on_wallpaper_id", using: :btree

  create_table "wallpapers", force: true do |t|
    t.string   "filehash"
    t.string   "ext"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "category"
    t.string   "purity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
