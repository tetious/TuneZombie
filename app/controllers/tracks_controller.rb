class TracksController < ApplicationController
  respond_to :json

  def index
    @tracks = Track.order("name")

    respond_with @tracks
  end

  def show
    track = Track.find(params[:id])

    if params[:format] == "json"
      render json: track
    else
      send_track_with_range(track, request, response)
    end

  end

  def new
    @track = Track.new

    respond_with @track
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end

  # POST /tracks
  def create
    @track = Track.new(params[:track])
    flash[:notice] = "Track was successfully created." if @track.save
    respond_with @track
  end

  # PUT /tracks/1
  def update

    #TODO figure out why :track doesn't have rating
    params[:track][:rating] = params[:rating]

    respond_with Track.update(params[:id], params[:track])
  end

  # DELETE /tracks/1
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_with @track
  end

private
  def send_track_with_range(track, request, response)
    file_begin = 0
    file_size = track.file_size
    file_end = file_size - 1

    if request.headers["Range"]
      status_code = "206 Partial Content"
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      if match
        file_begin = match[1].to_i
        file_end = match[1] if match[2] && !match[2].empty?
      end
      response.header["Content-Range"] = "bytes " + file_begin.to_s + "-" + file_end.to_s + "/" + file_size.to_s
    else
      status_code = "200 OK"
    end
    response.header["Content-Length"] = (file_end.to_i - file_begin.to_i + 1).to_s

    response.header["Cache-Control"] = "public, must-revalidate, max-age=0"
    response.header["Pragma"] = "no-cache"
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"

    send_data(IO.binread(track.file_path, nil, file_begin),
              :filename => track.filename,
              :disposition => "inline",
              :status => status_code,
              :stream =>  'true',
              :buffer_size  =>  4096)
  end

end
