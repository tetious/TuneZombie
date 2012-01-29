class MusicController < ApplicationController

  # music/tab/albums/?album_name=foo
  def index
    @items = Hash[*params[:specs].split('/')]
    parse_glob 'boo'
    render text: 'bar'
  end

end
