class GenresController < ApplicationController
  respond_to :json

  def index
    respond_with Genre.all
  end

  def show
    respond_with Genre.find(params[:id])
  end

  def create
    respond_with Genre.create(params[:genre])
  end

  def update
    respond_with Genre.update(params[:id], params[:genre])
  end

  def destroy
    respond_with Genre.find(params[:id]).destroy
  end
end
