class AlbumsController < ApplicationController
  respond_to :html, :json

  def index
    @albums = Album.all

    respond_with @albums
  end

  def show
    @albums = Albums.find(params[:id])

    respond_with @album
  end

  def new
    @album = Albums.new

    respond_with @album
  end

  def edit
    @album = Albums.find(params[:id])
  end

  def create
    @album = Albums.new(params[:album])
    respond_with @album
  end

  def update
    @album = Albums.find(params[:id])
    respond_with @album
  end

  def destroy
    @album = Albums.find(params[:id])
    @album.destroy

    respond_with @album
  end

end
