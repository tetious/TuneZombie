require ["dijit/layout/BorderContainer"
  "dijit/layout/TabContainer"
  "dijit/layout/ContentPane"]

playTrack = (e) ->
  row = e.currentTarget
  $(".album_list_item").removeClass("row_playing")
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
  $(".album_list_item").click ->
    $(".album_list_item").removeClass("row_selected")
    $(@).addClass("row_selected")

  $(".album_list_item").dblclick(playTrack)
  $("#player").hide()