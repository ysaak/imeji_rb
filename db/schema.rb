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

ActiveRecord::Schema.define(version: 20150727214835) do

  create_table "colors", force: :cascade do |t|
    t.string   "red",          limit: 255
    t.string   "green",        limit: 255
    t.string   "blue",         limit: 255
    t.float    "percent",      limit: 24
    t.integer  "wallpaper_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colors", ["wallpaper_id"], name: "index_colors_on_wallpaper_id", using: :btree

  create_table "parameters", id: false, force: :cascade do |t|
    t.string "name",  limit: 255, null: false
    t.string "value", limit: 255, null: false
  end

  add_index "parameters", ["name"], name: "index_parameters_on_name", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",             limit: 255,             null: false
    t.integer  "alias_of_id",      limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "wallpaper_id",     limit: 4
    t.string   "bg_x",             limit: 255
    t.string   "bg_y",             limit: 255
    t.integer  "wallpapers_count", limit: 4,   default: 0, null: false
    t.integer  "category",         limit: 4,   default: 0, null: false
  end

  add_index "tags", ["alias_of_id"], name: "index_tags_on_alias_of_id", using: :btree

  create_table "tags_wallpapers", id: false, force: :cascade do |t|
    t.integer "tag_id",       limit: 4, null: false
    t.integer "wallpaper_id", limit: 4, null: false
  end

  add_index "tags_wallpapers", ["tag_id"], name: "index_tags_wallpapers_on_tag_id", using: :btree
  add_index "tags_wallpapers", ["wallpaper_id"], name: "index_tags_wallpapers_on_wallpaper_id", using: :btree

  create_table "wallpapers", force: :cascade do |t|
    t.string   "filehash",   limit: 255
    t.string   "ext",        limit: 255
    t.integer  "size",       limit: 4
    t.integer  "width",      limit: 4
    t.integer  "height",     limit: 4
    t.string   "rating",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
