class Helper
  @RatingTag: (el, rating) ->
    console.log("Rating tag: "+ rating)
    $(el).html("<img src='/assets/rating/#{rating}_star.png'/>")

window.App =
  Models: {}
  Views: {}

  init: ->

    @allAlbums = new App.Models.Albums
    
#    @allArtists = new App.Models.Artists
#    @allArtists.fetch()

    @albums = new App.Models.Albums
    @albums.fetch success: (collection) => @allAlbums.reset collection.models 
    @albumsList = new App.Views.AlbumList collection: @albums
    @albumBoxList = new App.Views.AlbumBoxList collection: @albums
    
    @player = new App.Models.Player
    @playerView = new App.Views.PlayerView model: @player, el: $("#jquery_jplayer_1")
    @player.bindEvents()

    @playerPlaylist = new App.PlayerPlaylist
    @playerPlaylist.useCollection(@albums)

    $("#search-box").keyup =>
      @albums.reset @allAlbums.query name: {$likeI: $("#search-box").val() }

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

App.Helper = Helper
