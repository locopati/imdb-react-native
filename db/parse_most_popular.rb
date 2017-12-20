require 'nokogiri'
require 'open-uri'
require 'time'

# my approach in doing a quick parsing project like this is build in checks as they are needed
# rather than try to anticipate all the things that _could_ go wrong
# over time, the sanity checks will grow as strange things are encountered
# for now, especially in a one-off project like this that has undefined expectations, we're going to be optimistic
# and rely on getting it right by running the script and fixing parsing problems that come up as we go

IMDB = 'http://www.imdb.com'
MOST_POPULAR = %w(/chart/tvmeter /chart/moviemeter)

# utility method to parse docs with consistent options and host handling
def parse_uri(uri)
  puts "parsing #{uri}"
  uri = IMDB + uri if uri =~ /^\//
  Nokogiri::HTML(open uri) { |config| config.recover.noent }
end

# parse the most popular page
def parse_most_popular(uri, count = nil)
  doc = parse_uri uri

  # we are only going to sample to first few
  rows = doc.css '.lister-list tr'
  most_popular = rows[0, count || rows.count].map { |row| parse_summary row }

  # continue by parsing each show/movie
  most_popular.map { | watchable | parse_details watchable }
end

# parse each item in the most popular page
def parse_summary(row)
  result = {}

  result['title'] = row.css('.titleColumn a').text.strip
  result['imdb_uri'] = IMDB + row.css('.titleColumn a').attribute('href').value.strip

  rating_element = row.css('.imdbRating strong')
  unless rating_element.empty?
    rating_match = rating_element.attribute('title').value.match /^(.*) based on (.*) user ratings$/
    if rating_match
      result['imdb_rating'] = rating_match[1].to_i
      result['imdb_rating_count'] = rating_match[2].to_i
    end
  end

  #puts result
  result
end

# get the details of a watchable item from its page
def parse_details(watchable)
  puts "parsing details #{watchable['title']}"
  doc = parse_uri watchable['imdb_uri']
  type = doc.css('meta[property="og:type"]').attribute('content').value

  # title wrapper
  watchable['rating'] = doc.at_css('.title_wrapper [itemprop="contentRating"]').attribute('content').value
  watchable['minutes'] = parse_datetime(doc.at_css('.title_wrapper [itemprop="duration"]').attribute('datetime').value)
  watchable['genres'] = doc.css('.title_wrapper [itemprop="genre"]').map {|i| i.text.strip }

  # plot summary wrapper
  watchable['description'] = doc.css('.plot_summary_wrapper [itemprop="description"]').text.strip

  # tv shows
  if type == 'video.tv_show'
    #watchable['creator'] = doc.css('[itemprop="creator"]').text.strip
    #watchable['stars'] = doc.css('[itemprop="actors"]').map {|i| parse_name i.text }

    episode_guide_url = doc.css('.np_episode_guide').attribute('href').value
    watchable['imdb_episode_guide_uri'] = episode_guide_url

    season_uris = doc.css('.seasons-and-year-nav div:nth-of-type(3) a').map {|i| i.attribute('href').value }.reverse
    watchable['episodes'] = season_uris.map { |uri| parse_season uri }.flatten
  # movies
  elsif type == 'video.movie'
    watchable['release_date'] = Time.parse doc.at_css('.title_wrapper [itemprop="datePublished"]').attribute('content').value
    watchable['metacritic_score'] = doc.css('.plot_summary_wrapper .metacriticScore').text.strip.to_i
    #watchable['director'] = doc.css('.plot_summary_wrapper [itemprop="director"]').text.strip
    #watchable['writers'] = doc.css('.plot_summary_wrapper [itemprop="creator"]').map {|i| parse_name i.text }
    #watchable['stars'] = doc.css('.plot_summary_wrapper [itemprop="actors"]').map {|i| parse_name i.text }
  end

  # other
  watchable['poster_uri'] = doc.css('.title-overview .poster img').attribute('src').value

  #puts watchable
  watchable
end

# utility method to parse datetimes using IMDBs formatting
def parse_datetime(timestr)
  m = timestr.match /^PT(\d+)M$/
  m ? m[1].to_i : -1
end

# parse a tv show season
def parse_season(uri)
  doc = parse_uri uri
  season_number = doc.css('#episode_top').text.sub(/Season\u00A0/,'').to_i
  episodes = doc.css('.eplist .list_item')
  episodes.map { |e| parse_episode e }.map { |e| e['season_number'] = season_number; e }
end

# parse a tv show episode
def parse_episode episode
  result = {}
  result['title'] = episode.at_css('.info [itemprop="name"]').text.strip
  result['imdb_uri'] =  IMDB + episode.at_css('.info [itemprop="name"]').attribute('href').value
  result['image_uri'] = episode.at_css('.image img')&.attribute('src')&.value
  result['episode_number'] = episode.at_css('[itemprop="episodeNumber"]').attribute('content').value.to_i
  result['airdate'] = begin
    airdate = episode.at_css('.airdate').text.strip
    Time.parse airdate if airdate != ''
  rescue
    nil
  end
  result['imdb_rating'] = episode.at_css('.ipl-rating-star__rating')&.text
  result['description'] = episode.at_css('[itemprop="description"]').text.strip
  result
end

def parse_name name
  name.strip.sub(/\s?(\(.*\))?,?$/,'') if name
end