class App.Models.Track extends Backbone.Model

  initialize: ->
    @time = 0
    @timePlayed = 0

  url: ->
    if @id
      "/tracks/#{@id}.json"
    else
      "/tracks"

  markPlaying: =>
    @trigger('playing')
    @playing = true

  markStopped: =>
    if @playing
      @trigger('stopped')
      @playing = false
      tp = new App.Models.TrackPlays
      tp.create(user_id: App.user_id, track_id: @id, played_time: @timePlayed)

      @time = 0
      @timePlayed = 0

  setRating: (e) =>
    if e.offsetX
      offX = e.offsetX
    else
      # this magical garbage is here because Firefox decided not to implement offsetX
      # the 6 is the width of the layout slider div
      offX = e.pageX - $(e.target).position().left - $("#app-left").width() - 6

    newRating = Math.round((offX + 5) / 16)
    @set("rating", newRating)
    @save()

  timeTick: (time) =>
    if @time < time # if we've moved forward in time
      @timePlayed += time - @time

    @time = time
    console.log ("currentTime: #{time} timePlayed: #{@timePlayed}")

  albumName: =>
    @album ||= App.albums.get(@get("album_id"))
    @album.get("name")

  media: =>
    tmp = {}
    tmp[@get("file_ext")] = "/tracks/#{@id}"
    tmp

class App.Models.Tracks extends Backbone.QueryCollection
  url: '/tracks'
  model: App.Models.Track