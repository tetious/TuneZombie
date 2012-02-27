class AlbumArtController < ApplicationController
  def show
    album = Album.find(params[:id])

    if album.art_type
      send_file album.art_url, type: album.art_mime_type
    else
      redirect_to view_context.image_path "blank_album.jpg"
    end

  end
end
