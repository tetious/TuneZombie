class App.Views.PlayerView extends Backbone.View

  events:
    "click #player-rating": "updateRating"

  initialize: ->
    @model.on('new_track', @play, this)

    $("#app-header").mouseenter @fadeInTitleCard
    $("#app-header").mouseleave @fadeOutTitleCard
#    $("#player-rating").click @updateRating

    # init player so it doesn't look strange
    $(@el).jPlayer(
      media: {mp3: ""}
      swfPath: "/assets"
      supplied: "mp3"
    )

  updateRating: (e) =>
    @model.setRating(e)

  updateTitleCard: ->
    $("#player-album-name").text(@model.albumName())
    $("#player-track-name").text(@model.name())
    $("#player-rating").html("<img src='/assets/rating/#{@model.rating()}_star.png'/>")

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
        $(@el).jPlayer("setMedia", @model.media())
        $(@el).jPlayer("play")
        @trigger("playing")

      ended: =>
        @trigger("ended")

      play: =>
        @trigger("playing")

      timeupdate: (e) =>
        if e.jPlayer.status.currentTime == 0 and e.jPlayer.status.paused and @model.playing
          @trigger("stopped")
        else
          @model.timeTick(e.jPlayer.status.currentTime)

      swfPath: "/assets"
      supplied: @model.fileExt()
    )

    @updateTitleCard()

