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

ActiveRecord::Schema.define(version: 20140603213923) do

  create_table "property_site_values", force: true do |t|
    t.integer  "property_site_id"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "propertysite_id"
  end

  add_index "property_site_values", ["propertysite_id"], name: "index_property_site_values_on_propertysite_id", using: :btree

  create_table "property_sites", force: true do |t|
    t.string   "title"
    t.string   "propertytype"
    t.integer  "beds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "searchtext"
  end

  create_table "search_params", force: true do |t|
    t.string   "searchtitle"
    t.string   "searchparam"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
  end

  create_table "tests", force: true do |t|
    t.string   "t"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
