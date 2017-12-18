require 'nokogiri'
require 'open-uri'

# my approach in doing a quick parsing project like this is build in checks as they are needed
# rather than try to anticipate all the things that _could_ go wrong
# over time, the sanity checks will grow as strange things are encountered
# for now, especially in a one-off project like this that has undefined expectations, we're going to be optimistic
# and rely on getting it right by running the script and fixing parsing problems that come up as we go

IMDB = 'http://www.imdb.com'

# utility method to parse docs with consistent options and host handling
def parse_uri(uri)
  puts "parsing #{uri}"
  Nokogiri::HTML(open IMDB + uri) { |config| config.recover.noent }
end

# parse the most popular page
def parse_most_popular(uri)
  doc = parse_uri uri

  # we are only going to sample to first few
  rows = doc.css '.lister-list tr'
  most_popular = rows[0,1].map { |row| parse_summary row }

  # continue by parsing each show/movie
  most_popular.map { | watchable | parse_details watchable }
end

# parse each item in the most popular page
def parse_summary(row)
  result = {}

  result['title'] = row.css('.titleColumn a').text.strip
  result['uri'] = row.css('.titleColumn a').attribute('href').value.strip

  rating_element = row.css('.imdbRating strong')
  unless rating_element.empty?
    rating_match = rating_element.attribute('title').value.match /^(.*) based on (.*) user ratings$/
    if rating_match
      result['imdbRating'] = rating_match[1]
      result['imdbRatingCount'] = rating_match[2]
    end
  end

  puts result
  result
end

# get the details of a watchable item from its page
def parse_details(watchable)
  puts "parsing details #{watchable['title']}"
  doc = parse_uri watchable['uri']
  type = doc.css('meta[property="og:type"]').attribute('content').value

  # title wrapper
  watchable['rating'] = doc.css('.title_wrapper [itemprop="contentRating"]').first.attribute('content').value
  watchable['length'] = parse_datetime(doc.css('.title_wrapper [itemprop="duration"]').first.attribute('datetime').value)
  watchable['genres'] = doc.css('.title_wrapper [itemprop="genre"]').map {|i| i.text.strip }

  # plot summary wrapper
  watchable['description'] = doc.css('.plot_summary_wrapper [itemprop="description"]').text.strip

  if type == 'video.tv_show'
    watchable['episodeCount'] = doc.css('.np_episode_guide .bp_description .bp_sub_heading').text.strip.sub(' episodes', '').to_i
    episode_guide_url = doc.css('.np_episode_guide').attribute('href').value
    watchable['episodeGuideUri'] = episode_guide_url

    season_uris = doc.css('.seasons-and-year-nav div:nth-of-type(3) a').map {|i| i.attribute('href').value }.reverse
    season_uris.each { |uri| parse_season uri }
  elsif type == 'video.movie'
    watchable['releaseDate'] = doc.css('.title_wrapper [itemprop="datePublished"]').first.attribute('content').value
    watchable['director'] = doc.css('.plot_summary_wrapper [itemprop="director"]').text.strip
    watchable['writers'] = doc.css('.plot_summary_wrapper [itemprop="creator"]').map {|i| i.text.strip}
    watchable['stars'] = doc.css('.plot_summary_wrapper [itemprop="actors"]').map {|i| i.text.strip}
    watchable['metacriticScore'] = doc.css('.plot_summary_wrapper .metacriticScore').text.strip.to_i
  end

  # other
  watchable['poster'] = doc.css('.title-overview .poster img').attribute('src').value

  puts watchable
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

end

# here's where we kick things off
uris = %w(/chart/tvmeter /chart/moviemeter)
uris.map { | uri | parse_summary uri }.flatten
