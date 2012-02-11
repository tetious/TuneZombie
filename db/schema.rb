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

ActiveRecord::Schema.define(:version => 20120211024112) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "art_type"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "track_metadata", :force => true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.integer  "play_count"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "skip_count"
  end

  create_table "track_plays", :force => true do |t|
    t.datetime "played_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "track_id"
    t.integer  "user_id"
  end

  create_table "tracks", :force => true do |t|
    t.string   "track_type"
    t.integer  "size"
    t.string   "name"
    t.integer  "number"
    t.integer  "disc"
    t.datetime "date"
    t.text     "comments"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "artist_id"
    t.integer  "album_id"
    t.integer  "genre_id"
    t.integer  "composer_id"
    t.datetime "date_added"
    t.string   "filename"
    t.string   "file_hash"
    t.integer  "length"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
