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

ActiveRecord::Schema.define(version: 2021_07_24_041233) do

# Could not dump table "kaomojis" because of following StandardError
#   Unknown type '' for column 'has_bracket'

  create_table "selected_kaomojis", force: :cascade do |t|
    t.string "kaomoji", null: false
    t.index [nil], name: "index_selected_kaomojis_on_twitter_identifier", unique: true
  end

  create_table "tweets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "tweet_identifier", default: "f", null: false
    t.string "text", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "bracket_filtered_at"
    t.datetime "unicode_filtered_at"
    t.datetime "html_special_character_converted_at"
    t.index ["tweet_identifier"], name: "index_tweets_on_tweet_identifier", unique: true
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "twitter_identifier", null: false
    t.string "screen_name", null: false
    t.string "name", default: "", null: false
    t.string "desription", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_identifier"], name: "index_users_on_twitter_identifier", unique: true
  end

end
