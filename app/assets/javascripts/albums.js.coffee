jQuery ->
  $(".album_list_item").click ->
    album_id = @.id.split('_')[1]
    $.get '/albums/' + album_id, (data) ->
      $("#content_box").html(data)


