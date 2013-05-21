FactoryGirl.define do

  factory :album do
    name 'Test Album'

    factory :album_with_tracks do
      ignore do
        track_count 10
      end

      after(:create) do |album, evaluator|
        FactoryGirl.create_list(:track, evaluator.track_count, album: album)
      end
    end

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

end