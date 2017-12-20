require 'rails_helper'

RSpec.describe EpisodesController do
  it 'should return all episodes for a watchable' do
    episode_count = 10
    watchable =  create :watchable
    create_list :episode, episode_count, watchable: watchable
    get :index, params: { watchable_id: watchable.id }
    json = JSON.parse response.body
    expect(json.count).to eq episode_count
    # validate ordering by episode number
    expect(json.map { |e| e['episode_number'].to_i }).to eq (1..10).to_a
  end

  it 'should return all episodes for a season' do
    watchable = create :watchable
    season_count = 3
    create_season_episodes season_count, watchable
    (1..season_count).each do |n|
      get :season, params: { watchable_id: watchable.id, season_number: n }
      json = JSON.parse response.body
      expect(json.count).to eq n
    end
  end

  it 'should return an episode within a season' do
    watchable = create :watchable
    season_count = 3
    create_season_episodes season_count, watchable
    (1..season_count).each do |season_num|
      (1..season_num).each do |episode_num|
        get :show, params: { watchable_id: watchable.id, season_number: season_num, episode_number: episode_num }
        json = JSON.parse response.body
        episode = Episode.where(watchable: watchable, season_number:  season_num, episode_num: episode_num)
        json.each { |k, v| expect(v).to eq episode.send(k.to_sym) }
      end
    end
  end

  def create_season_episodes season_count, watchable
    (1..season_count).each do |n|
      create_list :episode, n, watchable: watchable, season_number: n
    end
  end
end