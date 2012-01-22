FactoryGirl.define do

  factory :album do
    name 'Test Album'
  end

  factory :artist do
    name 'Test Artist'
  end

  factory :track do
    name 'Test Track'
    filename 'test.m4a'
  end

end