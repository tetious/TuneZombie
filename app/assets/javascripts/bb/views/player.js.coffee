class App.Views.PlayerView extends Backbone.View

  initialize: ->
    @model.on('change', @updateTitleCard, this)
    @model.on('new_track', @play, this)
    @volume = $.cookie('tz_volume') || 0.8

    $("#app-header").mouseenter @fadeInTitleCard
    $("#app-header").mouseleave @fadeOutTitleCard
    $("#player-rating").click @model.setRating
    $(".jp-previous").click @model.prev
    $(".jp-next").click @model.next

    # init player so it doesn't look strange
    $(@el).jPlayer(
      media: {mp3: ""}
      swfPath: "/assets"
      supplied: "mp3"
      volume: @volume
      volumechange: (e) =>
        @volume = e.jPlayer.options.volume
        $.cookie('tz_volume', @volume)
    )

  updateTitleCard: ->
    $("#player-album-name").text @model.track.albumName()
    $("#player-track-name").text @model.track.get("name")
    $("#player-rating").html("<img src='/assets/rating/#{@model.track.get("rating")}_star.png'/>")

  fadeInTitleCard: =>
    $("#player-title-bar").slideDown(100) unless @cardVisible
    @cardVisible = true
    clearTimeout(@timeout)

  fadeOutTitleCard: =>
    @timeout = setTimeout(@autoHideTitleCard, 5000)

  autoHideTitleCard: => # we only want to autohide if the user hasn't manually activated the card
    $("#player-title-bar").slideUp(100)
    @cardVisible = false

  play: ->
    $(@el).jPlayer("destroy")
    $(@el).jPlayer(
      ready: =>
        $(@el).jPlayer("setMedia", @model.track.media())
        $(@el).jPlayer("play")
        @trigger("playing")

      ended: =>
        @trigger("ended")

      play: =>
        @trigger("playing")

      volumechange: (e) =>
        @volume = e.jPlayer.options.volume
        $.cookie('tz_volume', @volume)

      timeupdate: (e) =>
        if e.jPlayer.status.currentTime == 0 and e.jPlayer.status.paused and @model.track.playing
          @trigger("stopped")
        else
          @model.track.timeTick(e.jPlayer.status.currentTime)

      swfPath: "/assets"
      solution: "flash, html"
      volume: @volume
      supplied: @model.track.get("file_ext")
    )

    @updateTitleCard()

