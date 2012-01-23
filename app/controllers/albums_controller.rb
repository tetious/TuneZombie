class AlbumsController < ApplicationController
  respond_to :html, :json

  def index
    @albums = Album.all

    respond_with @albums
  end

  def show
    @album = Album.find(params[:id])

    respond_with @album
  end

  def new
    @album = Album.new

    respond_with @album
  end

  def edit
    @album = Album.find(params[:id])
  end

  def create
    @album = Album.new(params[:album])
    respond_with @album
  end

  def update
    @album = Album.find(params[:id])
    respond_with @album
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_with @album
  end

end
