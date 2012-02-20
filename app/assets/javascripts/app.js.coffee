class Helper
  @RatingTag: (el, rating) ->
    console.log("Rating tag: "+ rating)
    $(el).html("<img src='/assets/rating/#{rating}_star.png'/>")

@app = window.app ? {}
@app.Helper = Helper
