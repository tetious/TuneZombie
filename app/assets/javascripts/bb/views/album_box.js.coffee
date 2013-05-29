class App.Views.AlbumBoxList extends Backbone.View
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendItem, this)

  render: ->
    $("#album-box-list").empty()
    @collection.each @appendItem
    this

  appendItem: (album) =>
    view = new App.Views.AlbumBox model: album, parent: this
    $("#album-box-list").append(view.render().el)

class App.Views.AlbumBox extends Backbone.View
  template: JST["album/album_box"]
  tagName: 'li'
  className: 'album-box'
  id: => 'album-box-' + @model.get('id')
  events:
    'click': 'showTrackBox'
    'click #track-list-close': 'closeTrackBox'

  initialize:  ->
    @parent = @options.parent
    @model.on('change', @renderBox, this)

  closeTrackBox: =>
    @parent.trackBox.remove() if @parent.trackBox
    $(".album-box").removeClass('ab-expanded').css('height', 210)

  showTrackBox: => #TODO fix magic numbers
    @closeTrackBox()
    @tracks = new App.Models.Tracks album_url = @model.url()
    @tracks.fetch()

    @parent.trackBox = new App.Views.TrackList(collection: @tracks)

    $(".album-box").removeClass('ab-expanded').css('height', 210)

    $(@parent.trackBox.render().el).css('height', 250).appendTo(@el)
    $(@el).css('height', 475).addClass('ab-expanded')

  render: ->
    $(@el).html(@template(album: @model.toJSON()))
    this