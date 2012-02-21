class App.Views.PlayerView extends Backbone.View

  initialize: ->
    @model.on('change', @render, this)
    $("#app-header").mouseenter @fadeInTitleCard
    $("#app-header").mouseleave @fadeOutTitleCard
    $("#player-rating").click @updateRating

  updateTitleCard: ->
    $("#player-album-name").text(@model.albumName())
    $("#player-track-name").text(@model.get("name"))
    $("#player-rating").html("<img src='/assets/rating/#{@model.get("rating")}_star.png'/>")

    @fadeInTitleCard()
    @fadeOutTitleCard()

  updateRating: (e) =>
    @model.setRating(e.offsetX)

  fadeInTitleCard: =>
    $("#player-title-bar").slideDown(100) unless @cardVisible
    @cardVisible = true
    clearTimeout(@timeout)

  fadeOutTitleCard: =>
    @timeout = setTimeout(@autoHideTitleCard, 5000)

  autoHideTitleCard: => # we only want to autohide if the user hasn't manually activated the card
    console.log("Autohiding title card. cardVisible:" + @cardVisible)
    $("#player-title-bar").slideUp(100)
    @cardVisible = false
    @cardToHide = false

  render: ->
    @updateTitleCard()
    this