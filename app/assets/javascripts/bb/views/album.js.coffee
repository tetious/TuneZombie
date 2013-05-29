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
