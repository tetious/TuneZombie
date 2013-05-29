class App.PlayerPlaylist

  useCollection: (collection) ->
    # if @collection 
    #   @collection.off("reset", @loadCollection)
    # @collection = collection
    # @collection.on("reset", @loadCollection, this)

  loadCollection: ->
    # @tracks = []
    # @trackCollection = new App.Models.Tracks
    # for item in @collection.models
    #   for track in item.tracks.models
    #     @tracks.push(track.id)  
    #     @trackCollection.add(track)

  prev: (id) -> 
   idx = @tracks.indexOf(id) - 1

   if idx < 0
     0
   else
     @trackCollection.get @tracks[idx]

  next: (id) -> 
   idx = @tracks.indexOf(id) + 1

   if idx > @tracks.length - 1
     0
   else
     @trackCollection.get @tracks[idx]
