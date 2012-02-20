class Player
  constructor: (@player, rows) ->
    $(@player).jPlayer(
      media: {mp3: ""}
      swfPath: "/assets"
      supplied: "mp3"
    )
    $("#player-title-bar").hide()

    $("#app-header").mouseenter @fadeInTitleCard
    $("#app-header").mouseleave @fadeOutTitleCard

    #App = window.app

    @playlist = _.map(rows, (i) -> parseInt $(i).attr('data-track-id'))

    #_.map(t,function(i) { return {id: i.id, playing: $(i).hasClass("row_playing") } })
    #var n = _.map(t, function (i) { return $(i).attr('data-track-id'); })

  # update the server
  updateCurrentTrackMetadata: ->
    #TODO: do something

  markPlaying: ->
    $(".track_list_item").removeClass("row_playing")
    $("#track_#{@current.id}").addClass("row_playing")

    $("#player-album-name").text(@current.albumName())
    $("#player-track-name").text(@current.get("name"))
    rating = @current.get("rating")
    $("#player-rating").html("<img src='/assets/rating/#{rating}_star.png'/>")

    @fadeInTitleCard()
    @cardVisible = false # autohide only happens if it is marked not visible
    setTimeout(@autoHideTitleCard, 5000)

  fadeInTitleCard: =>
    @cardVisible = true
    $("#player-title-bar").slideDown(100)

  fadeOutTitleCard: =>
    @cardVisible = false
    $("#player-title-bar").slideUp(100)

  autoHideTitleCard: => # we only want to autohide if the user hasn't manually activated the card
    console.log("Autohiding title card. cardVisible:" + @cardVisible)
    @fadeOutTitleCard() if @cardVisible == false

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

    @current = new App.Models.Track id: id

    @current.fetch success: =>
      $(@player).jPlayer(
          ready: =>
            $(@player).jPlayer("setMedia", @current.media())
            $(@player).jPlayer("play")
            @markPlaying()

          ended: =>
            @updateCurrentTrackMetadata()
            #get the next track
            @play(@.next())

          timeupdate: (e) =>
            @current.timeTick(e.jPlayer.status.currentTime)

          swfPath: "/assets"
          supplied: @current.get("file_ext")
      )

App.Player = Player