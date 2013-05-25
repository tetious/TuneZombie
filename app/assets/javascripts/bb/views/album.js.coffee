class App.Views.AlbumList extends Backbone.View
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendItem, this)
    @el = $("#album-list")

  render: ->
    $(@el).empty()
    @appendItem new App.Models.Album id: -1, name: "All"
    @collection.each @appendItem
    this

  appendItem: (album) =>
      view = new App.Views.AlbumListItem model: album
      $("#album-list").append(view.render().el)

class App.Views.AlbumListItem extends Backbone.View
  tagName: 'li'
  className: "album-list-item"

  initialize: ->
    @model.on('change', @render, this)

  render: ->
    $(@el).html(@model.get("name"))
    this

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
  tagName: 'li'
  className: 'album-box'
  id: => 'album-box-' + @model.get('id')
  events:
    'click': 'showTrackBox'
    'click #track-list-close': 'closeTrackBox'

  initialize: ->
    #@model.tracks.on('reset', @renderTracks, this)
    @model.on('change', @renderBox, this)

  closeTrackBox: =>
    $(".album-box").removeClass('ab-expanded').css('height', 210)

  showTrackBox: => #TODO fix magic numbers
    view = new App.Views.TrackList(collection: @model.tracks)

    $(".album-box").removeClass('ab-expanded').css('height', 210)

    $(view.render().el).css('height', 400).appendTo(@el)
    $(@el).css('height', 600).addClass('ab-expanded')

  render: ->
    $(@el).html(@template(album: @model.toJSON()))
    this
