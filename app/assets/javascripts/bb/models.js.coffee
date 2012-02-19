
class Track extends Backbone.Model

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

  title: ->
    @get("album_name") + " - " + @get("name")

  media: ->
    tmp = {}
    tmp[@.get("file_ext")] = "/tracks/#{@id}"
    tmp

@app = window.app ? {}
@app.Track = Track