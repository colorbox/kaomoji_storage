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

ActiveRecord::Schema.define(version: 2021_10_09_025101) do

  create_table "kaomojis", force: :cascade do |t|
    t.integer "tweet_id", null: false
    t.string "kaomoji", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_brackets"
    t.boolean "has_line_break"
    t.boolean "has_bracket"
    t.boolean "selected"
    t.datetime "unique_filtered_at"
    t.index ["kaomoji"], name: "index_kaomojis_on_kaomoji"
    t.index ["tweet_id"], name: "index_kaomojis_on_tweet_id"
    t.index ["unique_filtered_at"], name: "index_kaomojis_on_unique_filtered_at"
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

  create_table "unique_kaomojis", force: :cascade do |t|
    t.text "kaomoji", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "selected", default: false
    t.index ["kaomoji"], name: "index_unique_kaomojis_on_kaomoji", unique: true
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
