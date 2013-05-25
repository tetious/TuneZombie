require 'spec_helper'

describe 'Albums' do
  before(:all) do
    FactoryGirl.create(:user)
    FactoryGirl.create_list(:album_with_tracks, 5)
  end

  describe 'GET /albums' do

    it 'lists albums' do
      get albums_path, format: 'json'
      response.status.should be(200)
      expect(JSON.parse(response.body).length).to eq(5)
    end
  end

  describe 'GET /albums/n' do

    it 'gets a single album' do
      get album_path(2), format: 'json'
      response.status.should be(200)
      expect(JSON.parse(response.body)['id']).to eq(2)
    end

    it 'lists tracks for an album' do
      get album_tracks_path(1), format: 'json'
      response.status.should be(200)
      expect(JSON.parse(response.body).length).to eq(10)
    end

    describe 'when authenticated' do
      it 'lists tracks for an album with ratings' do
        FactoryGirl.create(:user)
        get user_path(1)

        get album_tracks_path(1), format: 'json'
        expect(JSON.parse(response.body).first['rating']).to eq(1)
      end
    end

  end

end
