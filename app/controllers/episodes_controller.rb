require_relative 'application_controller'

class EpisodesController < ApplicationController
  def index
    render json: Episode.where(watchable_id: request[:watchable_id]).order(:episode_number)
  end

  def season
    render json: Episode.where(episode_params)
  end

  def show
    render json: Episode.where(episode_params)
  end

  private

  def episode_params
    params.permit(:watchable_id, :season_number, :episode_number)
  end
end