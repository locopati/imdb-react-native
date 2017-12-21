require 'rails_helper'

RSpec.describe 'Episodes requests' do
  it 'should return all episodes for a watchable' do
    episode_count = 10
    watchable =  create :watchable
    create_list :episode, episode_count, watchable: watchable
    get "/watchables/#{watchable.id}/episodes", headers: {accept: 'application/json'}
    expect(response).to render_template(:index)
    json = JSON.parse response.body
    expect(json.count).to eq episode_count
    # validate ordering by episode number
    json.map { |e| expect(e['url']).to_not be_empty }
  end
end