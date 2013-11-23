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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131123062301) do

  create_table "properties", :force => true do |t|
    t.string   "customer_unique_id"
    t.string   "owner_name"
    t.string   "tenant_name"
    t.string   "street_address"
    t.integer  "zipcode"
    t.integer  "plus_four"
    t.string   "state"
    t.string   "phone"
    t.string   "email"
    t.date     "finish_date"
    t.date     "consent_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "city"
  end

  create_table "record_lookups", :force => true do |t|
    t.integer  "property_id"
    t.integer  "utility_type_id"
    t.string   "acct_num"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "record_lookups", ["property_id"], :name => "index_record_lookups_on_property_id"
  add_index "record_lookups", ["utility_type_id"], :name => "index_record_lookups_on_utility_type_id"

  create_table "recordings", :force => true do |t|
    t.integer  "acctnum"
    t.date     "read_date"
    t.string   "consumption"
    t.integer  "days_in_month"
    t.integer  "utility_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "recordings", ["utility_type_id"], :name => "index_recordings_on_utility_type_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "utility_types", :force => true do |t|
    t.string   "typeName"
    t.string   "units"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
