class AlbumArtController < ApplicationController
  def show
    album = Album.find(params[:id])

    send_file album.art_url, :type=>"image/#{ album.art_type }"
  end
end
