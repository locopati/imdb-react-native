json.merge! episode.attributes
json.url episode_watchable_path(season_number: episode.season_number, episode_number: episode.episode_number)