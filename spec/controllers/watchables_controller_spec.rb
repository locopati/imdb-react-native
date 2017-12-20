require 'rails_helper'

RSpec.describe WatchablesController do
  it 'should return all watchables' do
    watchable_count = 10
    create_list :watchable, watchable_count
    get :index
    json = JSON.parse response.body
    expect(json.length).to eq(watchable_count)
  end
end