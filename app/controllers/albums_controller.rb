class AlbumsController < ApplicationController
  respond_to :json

  def index
    respond_with Album.order("name")
  end

  def show
    respond_with Album.find(params[:id])
  end


  def update
    respond_with Album.update(params[:id], params[:album])
  end

  def destroy
    respond_with Album.find(params[:id]).destroy
  end

end
