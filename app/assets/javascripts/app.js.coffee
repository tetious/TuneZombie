class Helper
  @RatingTag: (el, rating) ->
    console.log("Rating tag: "+ rating)
    $(el).html("<img src='/assets/rating/#{rating}_star.png'/>")

window.App =
  Models: {}
  Views: {}

  init: ->

    @albums = new App.Models.Albums
    @albumsList = new App.Views.AlbumList collection: @albums
    @albumBoxList = new App.Views.AlbumBoxList collection: @albums
    @albums.fetch()

    @artists = new App.Models.Artists
    @artists.fetch()

    @user_id = $("body").data("user-id")

    @layout = $('#app').layout (
      north:
        closable: false
        resizable: false
        spacing_open: 0
        size: 70
      west: minSize: 100
    )
    @layout.allowOverflow('north')

    $("#left-accordion").accordion icons:false, autoHeight: false

    $("#jp_container_1").css left: "#{($(document).width() / 2) - 240 }px"

    @player = new App.Player("#jquery_jplayer_1", $(".track-list-item"))

    $(".track-list-item").click -> # highlight track
      $(".track-list-item").removeClass("row_selected")
      $(@).addClass("row_selected")

    $(".track-list-item").dblclick (e) => # play track
      @player.play($(e.currentTarget).attr("data-track-id"))



App.Helper = Helper
