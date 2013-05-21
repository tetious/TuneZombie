require 'spec_helper'

describe 'Music' do
  describe 'GET /music' do

    describe 'when un-authenticated' do
      it 'redirects to login page' do
        get music_index_path
        response.code.should == '302'
        response.should redirect_to(users_path)
      end
    end

    describe 'when authenticated' do
      it 'renders music#index view' do
        FactoryGirl.create(:user)
        get user_path(1)

        get music_index_path
        assert_select 'title', text: 'TuneZombie'
      end
    end

  end
end
