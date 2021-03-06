require 'rails_helper'

RSpec.describe EpisodesController do
  it 'should return all episodes for a watchable' do
    episode_count = 10
    watchable =  create :watchable
    create_list :episode, episode_count, watchable: watchable
    request.headers.merge! accept:'application/json'
    get :index, params: { watchable_id: watchable.id }
    expect(assigns(:episodes).count).to eq episode_count
  end

  it 'should return all episodes for a season' do
    watchable = create :watchable
    season_count = 3
    create_season_episodes season_count, watchable
    (1..season_count).each do |n|
      request.headers.merge! accept:'application/json'
      get :season, params: { watchable_id: watchable.id, season_number: n }
      expect(assigns(:episodes).count).to eq n
    end
  end

  it 'should return an episode within a season' do
    watchable = create :watchable
    season_count = 3
    create_season_episodes season_count, watchable
    (1..season_count).each do |season_num|
      (1..season_num).each do |episode_num|
        request.headers.merge! accept:'application/json'
        params = { watchable_id: watchable.id, season_number: season_num, episode_number: episode_num }
        get :show, params: params
        expect(assigns(:episode)).to eq Episode.find_by(params)
      end
    end
  end

  def create_season_episodes season_count, watchable
    (1..season_count).each do |n|
      create_list :episode, n, watchable: watchable, season_number: n
    end
  end
end