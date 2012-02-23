class MusicController < ApplicationController

  respond_to :html

  # music/tab/albums/?album_name=foo
  def index
    if User.current
      respond_with Album.order(:name)
    else
      redirect_to users_path
    end
  end
end
