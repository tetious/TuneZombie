class App.Models.Track extends Backbone.Model

  initialize: ->
    @time = 0
    @timePlayed = 0

  url: ->
    if @id
      "/tracks/#{@id}.json"
    else
      "/tracks"

  timeTick: (time) ->
    if @time < time # if we've moved forward in time
      @timePlayed += time - @time

    @time = time
    console.log ("currentTime: #{time} timePlayed: #{@timePlayed}")

  albumName: ->
    @album ||= App.albums.get(@get("album_id"))
    @album.get("name")

  media: ->
    tmp = {}
    tmp[@get("file_ext")] = "/tracks/#{@id}"
    tmp

class App.Models.Tracks extends Backbone.Collection
  url: '/tracks'
  model: App.Models.Track

class App.Models.Albums extends Backbone.Collection
  url: '/albums'

class App.Models.Artists extends Backbone.Collection
  url: '/artists'
