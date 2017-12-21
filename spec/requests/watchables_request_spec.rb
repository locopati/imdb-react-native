require 'rails_helper'

RSpec.describe 'Watchables requests' do
  it 'should get all watchables' do
    watchable_count = 10
    create_list :watchable, watchable_count
    get '/watchables', headers: {accept: 'application/json'}
    expect(response).to render_template(:index)
    json = JSON.parse(response.body)
    expect(json.length).to eq watchable_count
    json.map {|w| expect(w['url']).to_not be_empty}
  end

  it 'should return seasons for a watchable' do
    watchable = create :watchable
    season_count = 3
    (1..season_count).each do |n|
      create_list :episode, n, watchable: watchable, season_number: n
    end
    get "/watchables/#{watchable.id}", headers: {accept: 'application/json'}
    expect(response).to render_template(:show)
    json = JSON.parse(response.body)
    seasons = json['seasons']
    expect(seasons).to_not be_nil
    expect(seasons.count).to eq season_count
    seasons.each_with_index do |s, idx|
      expect(s['season_number']).to eq idx+1
      expect(s['url']).to_not be_empty
    end
  end
end