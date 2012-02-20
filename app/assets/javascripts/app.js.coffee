class Helper
  @RatingTag: (el, rating) ->
    console.log("Rating tag: "+ rating)
    $(el).html("<img src='/assets/rating/#{rating}_star.png'/>")

window.App =
  Models: {}

  init: ->

    @albums = new App.Models.Albums
    @albums.fetch()
    @artists = new App.Models.Artists
    @artists.fetch()

    @layout = $('#app').layout (
      north:
        closable: false
        resizable: false
        spacing_open: 0
        size: 70
      west: minSize: 100
    )
    @layout.allowOverflow('north')

    $("#jp_container_1").css left: "#{($(document).width() / 2) - 240 }px"

    @player = new App.Player("#jquery_jplayer_1", $(".track_list_item"))

    $(".track_list_item").click -> # highlight track
      $(".track_list_item").removeClass("row_selected")
      $(@).addClass("row_selected")

    $(".track_list_item").dblclick (e) => # play track
      @player.play($(e.currentTarget).attr("data-track-id"))

    $(".track_rating").click (e) =>
      el = e.currentTarget
      id = $(el).parent().data("track-id")
      newRating = Math.round((e.offsetX + 5) / 16)

      track = new App.Models.Track id: id
      track.set("rating", newRating)
      track.save()

      Helper.RatingTag(el, newRating)
      Helper.RatingTag("#player-rating", newRating) if $(el).parent().hasClass("row_playing")


App.Helper = Helper
