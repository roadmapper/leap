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

ActiveRecord::Schema.define(:version => 20140325073458) do

  create_table "cvillegas_ready_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

  create_table "cvillegas_request_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "request_start_date"
    t.date    "request_end_date"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

  create_table "dominion_ready_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

  create_table "dominion_request_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "request_start_date"
    t.date    "request_end_date"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

  create_table "installed_measure_types", :force => true do |t|
    t.string   "installed_measures"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "null_accounts", :id => false, :force => true do |t|
    t.string "owner_name"
    t.string "customer_unique_id"
    t.string "company_name"
    t.string "acct_num"
  end

  create_table "properties", :force => true do |t|
    t.string   "customer_unique_id"
    t.string   "owner_name"
    t.string   "tenant_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.integer  "plus_four"
    t.string   "phone"
    t.string   "email"
    t.date     "finish_date"
    t.date     "consent_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "property_measures", :force => true do |t|
    t.integer  "property_id"
    t.integer  "measure_id"
    t.text     "comment"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "property_measures", ["measure_id"], :name => "index_property_measures_on_measure_id"
  add_index "property_measures", ["property_id"], :name => "index_property_measures_on_property_id"

  create_table "record_lookups", :force => true do |t|
    t.integer  "property_id"
    t.integer  "utility_type_id"
    t.string   "company_name"
    t.string   "acct_num"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "record_lookups", ["acct_num"], :name => "index_record_lookups_on_acct_num"
  add_index "record_lookups", ["property_id"], :name => "index_record_lookups_on_property_id"
  add_index "record_lookups", ["utility_type_id"], :name => "index_record_lookups_on_utility_type_id"

  create_table "recordings", :force => true do |t|
    t.string   "acctnum"
    t.date     "read_date"
    t.float    "consumption"
    t.integer  "days_in_month"
    t.integer  "utility_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "recordings", ["acctnum"], :name => "index_recordings_on_acctnum"
  add_index "recordings", ["utility_type_id"], :name => "index_recordings_on_utility_type_id"

  create_table "stagings", :force => true do |t|
    t.string   "acctnum"
    t.date     "read_date"
    t.float    "consumption"
    t.integer  "days_in_month"
    t.integer  "utility_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "stagings", ["utility_type_id"], :name => "index_recordings_on_utility_type_id"

  create_table "temp_cvillegas_readings", :id => false, :force => true do |t|
    t.string "owner_name"
    t.string "customer_unique_id"
    t.date   "finish_date"
    t.string "company_name"
    t.string "acctnum"
    t.date   "read_date"
    t.float  "consumption"
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "temp_cvillegas_readings_good", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "read_date"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "gooddata"
  end

  create_table "temp_dominion_readings", :id => false, :force => true do |t|
    t.string "owner_name"
    t.string "customer_unique_id"
    t.date   "finish_date"
    t.string "company_name"
    t.string "acctnum"
    t.date   "read_date"
    t.float  "consumption"
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "temp_dominion_readings_good", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "read_date"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "gooddata"
  end

  create_table "temp_washingtongas_readings", :id => false, :force => true do |t|
    t.string "owner_name"
    t.string "customer_unique_id"
    t.date   "finish_date"
    t.string "company_name"
    t.string "acctnum"
    t.date   "read_date"
    t.float  "consumption"
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "temp_washingtongas_readings_good", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "read_date"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "gooddata"
  end

  create_table "test", :id => false, :force => true do |t|
    t.string "owner_name",     :limit => 25
    t.string "unique_id",      :limit => 8
    t.string "company",        :limit => 25
    t.string "account_number", :limit => 25
  end

  create_table "uploads", :force => true do |t|
    t.string   "file_name"
    t.string   "status"
    t.datetime "upload_date"
    t.datetime "process_date"
    t.string   "uploaded_by"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

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

  create_table "washingtongas_ready_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

  create_table "washingtongas_request_accounts", :id => false, :force => true do |t|
    t.string  "owner_name"
    t.string  "acctnum"
    t.date    "request_start_date"
    t.date    "request_end_date"
    t.integer "acceptedDatapoints", :limit => 8, :default => 0, :null => false
  end

end
