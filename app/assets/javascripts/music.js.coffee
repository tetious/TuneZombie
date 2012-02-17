require ["dijit/layout/BorderContainer"
  "dijit/layout/TabContainer"
  "dijit/layout/ContentPane"]

jQuery ->
  $(".album_list_item").click ->
    $(".album_list_item").removeClass("row_selected")
    $(@).addClass("row_selected")

  $(".album_list_item").dblclick ->
    $(".album_list_item").removeClass("row_playing")
    $(@).addClass("row_playing")



