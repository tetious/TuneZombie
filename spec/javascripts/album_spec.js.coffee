describe "Album", ->
  beforeEach ->
    @album = new App.Models.Album
      name: "Bob Barker's Greatest Hits"
      tracks: [
        {name: "Dandy Mushroom", number: 1, rating: 4, time: 360}
        {name: "Happy Mushroom", number: 3, rating: 0, time: 260}
        {name: "Dead Mushroom", number: 2, rating: 1, time: 122}
      ]

  it "Should populate tracks", ->
    expect(@album.tracks.length).toEqual(3)

  it "Should sort tracks by number", ->
    expect(track.get("number")).toEqual(i + 1) for track, i in @album.tracks.models

