class App.Views.AlbumBoxList extends Backbone.View

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendItem, this)

  render: ->
    $("#album-box-list").empty()
    @collection.each @appendItem
    this

  appendItem: (album) =>
    view = new App.Views.AlbumBox model: album
    $("#album-box-list").append(view.render().el)

class App.Views.AlbumBox extends Backbone.View
  template: JST["album/album_box"]
  tagName: 'table'
  className: "album-box-wrapper"

  initialize: ->
    #@model.tracks.on('reset', @renderTracks, this)
    @model.on('change', @renderBox, this)

  renderBox: =>
    $(@el).html(@template(album: @model.toJSON()))
    this

  renderTracks: =>
    view = new App.Views.TrackList(collection: @model.tracks)
    @$("#album-block-tracks").html(view.render().el)
    this

  render: ->
    @renderBox()
    @renderTracks()
    this

class App.Views.TrackList extends Backbone.View
  tagName: 'table'
  className: 'album_block_tracks'

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendItem, this)

  render: ->
    @collection.each @appendItem
    this

  appendItem: (track) =>
    view = new App.Views.TrackListItem model: track
    $(@el).append(view.render().el)


class App.Views.TrackListItem extends Backbone.View
  template: JST["track/track"]
  tagName: 'tr'
  events:
    'dblclick': 'triggerPlay'
    'click .track_rating': 'updateRating'

  initialize: ->
    console.log("TrackListItem.initialize")
    @model.on('playing', @markRowPlaying, this)
    @model.on('stopped', @markRowStopped, this)
    @model.on('change', @render, this)

  triggerPlay: ->
    App.player.play(@model)

  updateRating: (e) ->
    @model.setRating(e)

  markRowPlaying: ->
    $(@el).addClass("row_playing")

  markRowStopped: ->
    $(@el).removeClass("row_playing")

  render: ->
    if @view
      @view.render()

    $(@el).html(@template(track: @model.toJSON()))
    this