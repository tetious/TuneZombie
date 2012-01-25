class MusicController < ApplicationController

  # music/tab/albums/?album_name=foo
  def index
    @items = Hash[*params[:specs].split('/')]

    render @items
  end

end
