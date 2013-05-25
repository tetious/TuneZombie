FactoryGirl.define do

  factory :album do
    name 'Test Album'

    factory :album_with_tracks do
      ignore do
        track_count 10
      end

      after(:create) do |album, evaluator|
        user = User.first || FactoryGirl.create(:user)

        evaluator.track_count.times do
          track = FactoryGirl.create :track, album: album
          FactoryGirl.create :track_metadata, track: track, user: user
        end
      end
    end

  end

  factory :user do
    sequence(:name) { |n| "test_user_#{n}" }
    
    password 'password'
  end

  factory :artist do
    name 'Test Artist'
  end

  factory :track do
    name 'Test Track'
    filename 'test.m4a'
    artist
    album
    sequence(:number)
    length 25
  end

  factory :track_metadata do
    track
    user
    rating 1
  end

end