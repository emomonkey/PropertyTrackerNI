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

ActiveRecord::Schema.define(version: 201410012221323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "emailtrans", force: true do |t|
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historic_analyses", force: true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "search_types_id"
    t.integer  "property_sites_id"
    t.integer  "search_params_id"
    t.string   "resulttext"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "beds"
    t.string   "propertytype"
    t.integer  "resultvalue"
    t.datetime "propdate"
  end

  add_index "historic_analyses", ["property_sites_id"], name: "index_historic_analyses_on_property_sites_id", using: :btree
  add_index "historic_analyses", ["search_params_id"], name: "index_historic_analyses_on_search_params_id", using: :btree
  add_index "historic_analyses", ["search_types_id"], name: "index_historic_analyses_on_search_types_id", using: :btree

  create_table "mailarticles", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profilesearchparams", force: true do |t|
    t.integer  "user_profile_id"
    t.integer  "search_params_id"
    t.datetime "appointment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "status"
    t.date     "solddate"
    t.datetime "lastdatescanned"
  end

  add_index "property_sites", ["title"], name: "index_property_sites_on_title", unique: true, using: :btree

  create_table "results_analyses", force: true do |t|
    t.integer  "SearchTypes_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "result_text"
  end

  add_index "results_analyses", ["SearchTypes_id"], name: "index_results_analyses_on_SearchTypes_id", using: :btree

  create_table "search_params", force: true do |t|
    t.string   "searchtitle"
    t.string   "searchparam"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
    t.datetime "searchdate"
  end

  create_table "search_types", force: true do |t|
    t.string   "searchtext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.string   "t"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transstatuses", force: true do |t|
    t.string   "name"
    t.string   "currentparam"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
