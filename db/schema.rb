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

ActiveRecord::Schema.define(:version => 20131105031613) do

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recordings", :force => true do |t|
    t.string   "name"
    t.date     "read_date"
    t.string   "consumption"
    t.integer  "utility_type_id_id"
    t.integer  "act_num_id"
    t.integer  "days_in_month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "utility_types", :force => true do |t|
    t.string   "typeName"
    t.string   "units"
    t.string   "acctNum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end