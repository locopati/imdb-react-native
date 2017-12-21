require_relative 'application_controller'

class EpisodesController < ApplicationController
  def index
    @episodes = Episode.where(watchable_id: request[:watchable_id]).order(:episode_number)
  end

  def season
    @episodes = Episode.where(episode_params)
    render template: 'episodes/index'
  end

  def show
    @episode = Episode.find_by(episode_params)
  end

  private

  def episode_params
    params.permit(:watchable_id, :season_number, :episode_number)
  end
end