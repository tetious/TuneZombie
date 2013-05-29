class App.Models.Albums extends Backbone.QueryCollection
  url: '/albums'
  model: App.Models.Album

class App.Models.Artists extends Backbone.QueryCollection
  url: '/artists'

class App.Models.TrackPlays extends Backbone.QueryCollection
  url: '/track_plays'


