describe "PlayerPlaylist", ->
  beforeEach ->
    @albums = new App.Models.Albums [
        {id: 1,
        name: "Bob Barker's Greatest Hits"
        tracks: [
          {id: 1, name: "Dandy Mushroom", number: 1, rating: 4, time: 360}
          {id: 2, name: "Dead Mushroom", number: 2, rating: 1, time: 122}
          {id: 3, name: "Happy Mushroom", number: 3, rating: 0, time: 260}
        ]}
        {id: 4,
        name: "Bob Barker's Dandiest Dittys"
        tracks: [
          {id: 6, name: "Mushroom Dance", number: 1, rating: 4, time: 360}
          {id: 7, name: "Mushroom Salad", number: 2, rating: 1, time: 122}
          {id: 8, name: "Mushroom Pool", number: 3, rating: 0, time: 260}
        ]}
    ]

    @playerPlaylist = new App.PlayerPlaylist
    @playerPlaylist.useCollection @albums

  it "returns next track", ->
    expect(@playerPlaylist.next(6).id).toEqual(7)

  it "returns previous track", ->
    expect(@playerPlaylist.prev(7).id).toEqual(6)

  it "returns next track across albums", ->
    expect(@playerPlaylist.next(3).id).toEqual(6)

  it "returns prev track across albums", ->     
    expect(@playerPlaylist.prev(6).id).toEqual(3)