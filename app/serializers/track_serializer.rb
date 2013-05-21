class TrackSerializer < ActiveModel::Serializer
  attributes :id, :time, :artist_name

  def time
    Time.at(object.length).strftime('%M:%S')
  end

  def artist_name
    object.artist.name
  end

end
