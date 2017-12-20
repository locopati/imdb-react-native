require 'rails_helper'

RSpec.describe WatchablesController do
  it 'should return all watchables' do
    watchable_count = 10
    create_list :watchable, watchable_count
    get :index
    json = JSON.parse response.body
    expect(json.length).to eq(watchable_count)
  end

  it 'should return a single watchable' do
    w = create :watchable
    get :show, params: { watchable_id: w.id }
    expect(response.body).to_not be_empty
    json = JSON.parse response.body
    json.each do |k, v|
      expect(v).to eq w.send(k.to_sym)
    end
  end
end