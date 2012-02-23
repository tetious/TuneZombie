class TracksController < ApplicationController
  respond_to :json

  def index
    respond_with Track.order("name")
  end

  def show
    track = Track.find(params[:id])

    if params[:format] == "json"
      render json: track
    else
      send_track_with_range(track, request, response)
    end
  end

  def update
    #TODO figure out why :track doesn't have rating
    params[:track][:rating] = params[:rating]

    respond_with Track.update(params[:id], params[:track])
  end

  #TODO: decide what this should do. Delete the media file?
  def destroy
  end

private

  # Hand rolled Range support so we don't need a proper web server or have to deal with
  # the implications thereof. It is likely there are bugs in this, and that there are better
  # ways to handle it all.
  #
  def send_track_with_range(track, request, response)
    file_begin = 0
    file_size = track.file_size
    file_end = file_size - 1

    if request.headers["Range"]
      logger.debug "Range present :" + request.headers["Range"]
      status_code = "206 Partial Content"
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      if match
        file_begin = match[1].to_i
        file_end = match[2].to_i unless match[2].empty?
        logger.debug "Range: file_begin: #{file_begin} file_end: #{file_end}"
      end
      response.header["Content-Range"] = "bytes #{file_begin + 1}-#{file_end + 1}/#{file_size}"
    else
      status_code = "200 OK"
    end
    response.header["Content-Type"] = track.mime_type
    response.header["Content-Length"] = (file_end - file_begin + 1).to_s

    response.header["Accept-Ranges"]=  "bytes" # This fixes ranges with Chrome
    response.header["Content-Transfer-Encoding"] = "binary"

    send_data(binread(track.file_path, nil, file_begin),
              :filename => track.filename,
              :disposition => "inline",
              :status => status_code,
              :stream =>  'true',
              :buffer_size  =>  4096)
  end

  def binread(name, range, offset)
    File.open(name, 'rb') do |f|
      f.seek(offset) if offset
      f.read(range)
    end
  end

end
