class App.Views.TrackListHeader extends Backbone.View

  render: ->
    $(@el).html(@template(album: @model.toJSON()))
    this


class App.Views.TrackList extends Backbone.View
  template: JST["track/track_list"]
  id: 'track-list'

  initialize: ->
    @collection.on('reset', @render, this)
    #@collection.on('add', @appendItem, this)
    #@collection.fetch(reset: true)

  render: ->
    $(@el).html(@template())
    @collection.each @appendItem
    this

  appendItem: (track) =>
    view = new App.Views.TrackListItem model: track
    $("#track-list-inner").append(view.render().el)

class App.Views.TrackListItem extends Backbone.View
  template: JST["track/track"]
  tagName: 'li'
  className: 'track-list-item'
  events:
    'dblclick': 'triggerPlay'
    'click .track_rating': 'updateRating'

  initialize: ->
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
    $(@el).html(@template(track: @model.toJSON()))
    this