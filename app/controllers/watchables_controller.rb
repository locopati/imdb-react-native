require_relative 'application_controller'

class WatchablesController < ApplicationController
  def index
    render json: Watchable.order(:title)
  end

  def show
    render json: Watchable.find(request[:watchable_id])
  end
end