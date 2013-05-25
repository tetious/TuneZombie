class App.Views.TrackList extends Backbone.View
  template: JST["track/track_list"]
  id: 'track-list-expando'

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendItem, this)

  render: ->
    #@collection.each @appendItem
    $(@el).html(@template())
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