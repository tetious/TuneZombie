class TrackPlaysController < ApplicationController
  respond_to :json

  def index
    respond_with TrackPlay.all
  end

  def show
    respond_with TrackPlay.find(params[:id])
  end

  def create
    respond_with TrackPlay.create(params[:track_play])
  end

  def update
    respond_with TrackPlay.update(params[:id], params[:track_play])
  end
end