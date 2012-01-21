class TracksController < ApplicationController
  respond_to :html, :json

  def index
    @tracks = Track.all

    respond_with @tracks
  end

  def show
    @track = Track.find(params[:id])

    respond_with @track
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
    @track = Track.find(params[:id])
    flash[:notice] = "Track was successfully updated." if @track.save
    respond_with @track
  end

  # DELETE /tracks/1
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_with @track
  end

end
