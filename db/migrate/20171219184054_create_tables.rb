class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :watchables do |t|
      t.string :title, null: false
      t.string :imdb_uri
      t.string :imdb_episode_guide_uri
      t.float :imdb_rating
      t.integer :imdb_rating_count
      t.string :rating
      t.integer :minutes
      t.string :description
      t.date :release_date
      t.integer :metacritic_score
      t.string :poster_uri
    end

    create_table :episodes do |t|
      t.integer :watchable_id
      t.string :title
      t.string :imdb_uri
      t.string :image_uri
      t.integer :season_number
      t.integer :episode_number
      t.date :airdate
      t.float :imdb_rating
      t.string :description
    end
    add_foreign_key :episodes, :watchables

    create_table :genres do |t|
      t.string :name
    end

    create_join_table :watchables, :genres
    add_foreign_key :genres_watchables, :watchables
    add_foreign_key :genres_watchables, :genres

  end
end
