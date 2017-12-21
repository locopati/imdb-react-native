require 'rails_helper'

RSpec.describe WatchablesController do
  it 'should return all watchables' do
    watchable_count = 10
    create_list :watchable, watchable_count
    request.headers.merge! accept:'application/json'
    get :index
    expect(assigns(:watchables).length).to eq watchable_count
  end

  it 'should return a single watchable' do
    w = create :watchable
    request.headers.merge! accept:'application/json'
    get :show, params: { watchable_id: w.id }
    expect(assigns(:watchable)).to eq w
  end
end