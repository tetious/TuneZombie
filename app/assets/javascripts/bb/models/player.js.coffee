class App.Models.Player extends Backbone.Model

  bindEvents: ->
    App.playerView.on("playing", @markPlaying, this)
    App.playerView.on("stopped", @markStopped, this)
    App.playerView.on("ended", @markStopped, this)

#  prev: -> #TODO: FIX THIS
#    idx = @playlist.indexOf(@current.id) - 1
#
#    if idx < 0
#      0
#    else
#      @playlist[idx]
#
#  next: -> #TODO: FIX THIS
#    idx = @playlist.indexOf(@current.id) + 1
#
#    if idx > @playlist.length - 1
#      0
#    else
#      @playlist[idx]

  markPlaying: ->
    @track.markPlaying()

  markStopped: ->
    @track.markStopped()

  albumName: -> @track.albumName
  name: -> @track.get("name")
  media: -> @track.media()
  timeTick: (time) -> @track.timeTick(time)
  fileExt: -> @track.get("file_ext")
  rating: -> @track.get("rating")
  playing: -> @track.playing

  play: (track) ->
    @track = track
    @trigger("new_track")


