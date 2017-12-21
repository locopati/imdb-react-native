require_relative 'application_controller'

class WatchablesController < ApplicationController
  def index
    @watchables = Watchable.order(:title)
  end

  def show
    @watchable = Watchable.find(request[:watchable_id])
  end
end