require './db/parse_most_popular'
require 'pp'

watchables = MOST_POPULAR.map { |uri| parse_most_popular uri, 3 }.flatten

watchables.each do | watchable |
  watchable['genres'] = watchable['genres'].map { |g| Genre.new name: g }
  watchable['episodes'] = watchable['episodes'] ? watchable['episodes'].map { |e| Episode.new e } : []
  w = Watchable.new watchable
  w.save
  w.episodes.each { |e| e.watchable = w; e.save }
end