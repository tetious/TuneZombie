describe "Album", ->
  beforeEach ->
    @album = new App.Models.Album
      name: "Bob Barker's Greatest Hits"
      tracks: [
        {name: "Dandy Mushroom", number: 1, rating: 4, time: 360}
        {name: "Happy Mushroom", number: 3, rating: 0, time: 260}
        {name: "Dead Mushroom", number: 2, rating: 1, time: 122}
        {name: "Dandy Mushroom", disc: 2, number: 1, rating: 4, time: 360}
        {name: "Happy Mushroom", disc: 2, number: 3, rating: 0, time: 260}
        {name: "Dead Mushroom", disc: 2, number: 2, rating: 1, time: 122}      ]

  it "Should populate tracks", ->
    expect(@album.tracks.length).toEqual(6)

  it "Should sort tracks by number", ->
    expect(@album.tracks.models[0].get("number")).toEqual(1)
    expect(@album.tracks.models[1].get("number")).toEqual(2)
    expect(@album.tracks.models[2].get("number")).toEqual(3)
    
    expect(@album.tracks.models[3].get("disc")).toEqual(2)
    expect(@album.tracks.models[3].get("number")).toEqual(1)
    expect(@album.tracks.models[4].get("number")).toEqual(2)
    expect(@album.tracks.models[5].get("number")).toEqual(3)
