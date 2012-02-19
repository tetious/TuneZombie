
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
  @app = window.app ? {}

  $('#app').layout (
    north:
      closable: false
      resizable: false
      spacing_open: 0
    west:
      minSize: 100

  )

  $("#jp_container_1").css left: "#{($(document).width() / 2) - 240 }px"

  @player = new @app.Player("#jquery_jplayer_1", $(".track_list_item"))

  $(".track_list_item").click ->
    $(".track_list_item").removeClass("row_selected")
    $(@).addClass("row_selected")

  $(".track_list_item").dblclick (e) =>
    @player.play($(e.currentTarget).attr("data-track-id"))


