module TracksHelper

  def rating_to_stars(rating)
    image_tag "rating/#{rating}_star.png"
  end

end
