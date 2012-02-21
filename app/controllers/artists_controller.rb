class ArtistsController < ApplicationController
  respond_to :json

  def index
    respond_with Artist.all
  end

  def show
    respond_with Artist.find(params[:id])
  end

  def create
    respond_with Artist.create(params[:artist])
  end

  def update
    respond_with Artist.update(params[:id], params[:artist])
  end

  def destroy
    respond_with Artist.find(params[:id]).destroy
  end
end
