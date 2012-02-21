class Player extends Backbone.Model
  constructor: (@player, rows) ->
    $(@player).jPlayer(
      media: {mp3: ""}
      swfPath: "/assets"
      supplied: "mp3"
    )
    $("#player-title-bar").hide()

    @playlist = _.map(rows, (i) -> parseInt $(i).attr('data-track-id'))

  prev: -> #TODO: FIX THIS
    idx = @playlist.indexOf(@current.id) - 1

    if idx < 0
      0
    else
      @playlist[idx]

  next: -> #TODO: FIX THIS
    idx = @playlist.indexOf(@current.id) + 1

    if idx > @playlist.length - 1
      0
    else
      @playlist[idx]

  play: (track) ->
    @current.markStopped() if @current
    $(@player).jPlayer("destroy")

    if track == 0 #TODO: fix the playlist
      return

    @current = track
    @trigger("play")

    @current.fetch success: =>
      $(@player).jPlayer(
          ready: =>
            $(@player).jPlayer("setMedia", @current.media())
            $(@player).jPlayer("play")
            @current.markPlaying()

          ended: =>
            @current.markStopped()
            @play(@next())

          play: =>
            @current.markPlaying()

          timeupdate: (e) =>
            if e.jPlayer.status.currentTime == 0 and e.jPlayer.status.paused and @current.playing
              console.log "Stopped"
              @current.markStopped()
            else
              @current.timeTick(e.jPlayer.status.currentTime)

          swfPath: "/assets"
          supplied: @current.get("file_ext")
      )

App.Player = Player