class MusicController < ApplicationController

  respond_to :html

  # music/tab/albums/?album_name=foo
  def index

    #@items = Hash[*params[:specs].split('/')] if !params[:specs].nil?
    #parse_glob 'boo'

    @albums = Album.all

    respond_with @albums
  end
end
