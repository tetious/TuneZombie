require 'spec_helper'

describe 'Albums' do
  describe 'GET /albums' do

    it 'lists albums' do
      FactoryGirl.create_list(:album_with_tracks, 5)
      get albums_path, format: 'json'
      response.status.should be(200)
      JSON.parse(response.body).length.should be(5)
    end

  end
end
