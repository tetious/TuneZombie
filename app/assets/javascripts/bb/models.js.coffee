class App.Models.Track extends Backbone.Model

  initialize: ->
    @time = 0
    @timePlayed = 0

  url: ->
    if @id
      "/tracks/#{@id}.json"
    else
      "/tracks"

  markPlaying: ->
    @trigger("play")
    @playing = true

  markStopped: ->
    if @playing
      @trigger("stop")
      @playing = false
      tp = new App.Models.TrackPlays
      tp.create(user_id: App.user_id, track_id: @id, played_time: @timePlayed)

      @time = 0
      @timePlayed = 0

  setRating: (offsetX) ->
    newRating = Math.round((offsetX + 5) / 16)
    @set("rating", newRating)
    @save()

  timeTick: (time) ->
    if @time < time # if we've moved forward in time
      @timePlayed += time - @time

    @time = time
    console.log ("currentTime: #{time} timePlayed: #{@timePlayed}")

  albumName: ->
    @album ||= App.albums.get(@get("album_id"))
    @album.get("name")

  media: ->
    tmp = {}
    tmp[@get("file_ext")] = "/tracks/#{@id}"
    tmp

class App.Models.Tracks extends Backbone.Collection
  url: '/tracks'
  model: App.Models.Track

class App.Models.Album extends Backbone.Model

  initialize: ->
    @tracks = new App.Models.Tracks()
    #@on("change", @fillTracks, this)
    @tracks.reset(@get("tracks"))

  #fillTracks: ->
  #  @tracks.reset(@get("tracks"))

class App.Models.Albums extends Backbone.Collection
  url: '/albums'
  model: App.Models.Album

class App.Models.Artists extends Backbone.Collection
  url: '/artists'

class App.Models.TrackPlays extends Backbone.Collection
  url: '/track_plays'
