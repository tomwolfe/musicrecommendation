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

ActiveRecord::Schema.define(:version => 20120131095828) do

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "track_id"
    t.integer  "value"
    t.float    "prediction"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ratings", ["created_at"], :name => "index_ratings_on_created_at"
  add_index "ratings", ["track_id"], :name => "index_ratings_on_track_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"
  add_index "ratings", ["value"], :name => "index_ratings_on_value"

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.string   "artist_name"
    t.float    "average_rating"
    t.string   "mb_id"
    t.string   "releases"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tracks", ["artist_name"], :name => "index_tracks_on_artist_name"
  add_index "tracks", ["name"], :name => "index_tracks_on_name"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
