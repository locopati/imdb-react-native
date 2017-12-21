json.merge! watchable.attributes
json.url url_for(watchable)
json.seasons do
  json.array! watchable.episodes.map { |e| e.season_number }.uniq.sort do |season_number|
    json.season_number season_number
    json.url season_watchable_path(watchable_id: watchable.id, season_number: season_number)
  end
end