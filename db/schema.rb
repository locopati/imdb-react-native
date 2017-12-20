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

ActiveRecord::Schema.define(version: 20171219184054) do

  create_table "episodes", force: :cascade do |t|
    t.integer "watchable_id"
    t.string "title"
    t.string "imdb_uri"
    t.string "image_uri"
    t.integer "season_number"
    t.integer "episode_number"
    t.date "airdate"
    t.float "imdb_rating"
    t.string "description"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "genres_watchables", id: false, force: :cascade do |t|
    t.integer "watchable_id", null: false
    t.integer "genre_id", null: false
  end

  create_table "watchables", force: :cascade do |t|
    t.string "title", null: false
    t.string "imdb_uri"
    t.string "imdb_episode_guide_uri"
    t.float "imdb_rating"
    t.integer "imdb_rating_count"
    t.string "rating"
    t.integer "minutes"
    t.string "description"
    t.date "release_date"
    t.integer "metacritic_score"
    t.string "poster_uri"
  end

end
