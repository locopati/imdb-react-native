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
end