# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090204223733) do

  create_table "email_archives", :force => true do |t|
    t.integer  "email_id"
    t.integer  "archiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "uid"
    t.integer  "response_id"
  end

  create_table "emails", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "uid"
    t.integer  "response_id"
  end

  create_table "forwards", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

end
