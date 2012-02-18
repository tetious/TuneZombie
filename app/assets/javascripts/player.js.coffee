class Player
  constructor: (@player, rows) ->
    $(@player).jPlayer(
      media: {mp3: ""}
      swfPath: "/assets"
      supplied: "mp3"
    )
    #@app = window.app

    @playlist = _.map(rows, (i) -> parseInt $(i).attr('data-track-id'))

    #_.map(t,function(i) { return {id: i.id, playing: $(i).hasClass("row_playing") } })
    #var n = _.map(t, function (i) { return $(i).attr('data-track-id'); })

  # update the server
  updateCurrentTrackMetadata: ->
    #TODO: do something

  markRowPlaying: ->
    $(".track_list_item").removeClass("row_playing")
    $("#track_#{@current.id}").addClass("row_playing")

  prev: ->
    idx = @playlist.indexOf(@current.id) - 1

    if idx < 0
      0
    else
      @playlist[idx]

  next: ->
    idx = @playlist.indexOf(@current.id) + 1

    if idx > @playlist.length - 1
      0
    else
      @playlist[idx]

  play: (id) ->

    $(@player).jPlayer("destroy")

    if id == 0
      return

    @current = new app.Track id: id

    @current.fetch success: =>
      $(@player).jPlayer(
          ready: =>
            $(@player).jPlayer("setMedia", @current.media())
            $(@player).jPlayer("play")
            @.markRowPlaying()

          ended: =>
            @.updateCurrentTrackMetadata()
            #get the next track
            @.play(@.next())

          timeupdate: (e) =>
            @current.timeTick(e.jPlayer.status.currentTime)

          swfPath: "/assets"
          supplied: @current.get("file_ext")
      )

@app = window.app ? {}
@app.Player = Player