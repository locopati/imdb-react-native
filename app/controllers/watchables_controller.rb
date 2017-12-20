require_relative 'application_controller'

class WatchablesController < ApplicationController
  def index
    render json: Watchable.order(:title)
  end
end