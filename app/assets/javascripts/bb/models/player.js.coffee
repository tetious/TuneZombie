class App.Models.Player extends Backbone.Model

  bindEvents: ->
    App.playerView.on("playing", @markPlaying, this)
    App.playerView.on("stopped", @markStopped, this)
    App.playerView.on("ended", @markStopped, this)
    App.playerView.on("ended", @next, this)

  markPlaying: ->
    @track.markPlaying()

  markStopped: ->
    @track.markStopped()

  next: =>
    @play App.playerPlaylist.next(@track.id)

  prev: =>
    @play App.playerPlaylist.prev(@track.id)

  change: ->
    @trigger("change")

  setRating: (e) =>
    @track.setRating(e)

  play: (track) ->
    if(!track)
      return
      
    if @track and @track.playing
      @markStopped()
    if @track
      @track.off("change", @change)

    @track = track
    track.on("change", @change, this)
    @trigger("new_track")

