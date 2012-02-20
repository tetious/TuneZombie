
playTrack = (e) ->
  row = e.currentTarget
  $(".track_list_item").removeClass("row_playing")
  $(row).addClass("row_playing")
  $(row).attr("data-track-id")

  media = {}
  media[$(row).attr("data-track-ext")] = "/tracks/" + $(row).attr("data-track-id")
  $("#jquery_jplayer_1").jPlayer("destroy");
  $("#player").show()

  $("#jquery_jplayer_1").jPlayer(
    ready: ->
      $(this).jPlayer("setMedia", media)
      $(this).jPlayer("play")

    swfPath: "/assets"
    supplied: $(row).attr("data-track-ext")
  )

jQuery ->
  @app = window.app

  @layout = $('#app').layout (
    north:
      closable: false
      resizable: false
      spacing_open: 0
      size: 70
    west:
      minSize: 100

  )
  @layout.allowOverflow('north')

  $("#jp_container_1").css left: "#{($(document).width() / 2) - 240 }px"

  @player = new @app.Player("#jquery_jplayer_1", $(".track_list_item"))

  $(".track_list_item").click -> # highlight track
    $(".track_list_item").removeClass("row_selected")
    $(@).addClass("row_selected")

  $(".track_list_item").dblclick (e) => # play track
    @player.play($(e.currentTarget).attr("data-track-id"))

  $(".track_rating").click (e) =>
    el = e.currentTarget
    id = $(el).parent().data("track-id")
    newRating = Math.round((e.offsetX + 5) / 16)

    track = new @app.Track id: id
    track.set("rating", newRating)
    track.save()

    @app.Helper.RatingTag(el, newRating)
    @app.Helper.RatingTag("#player-rating", newRating) if $(el).parent().hasClass("row_playing")



