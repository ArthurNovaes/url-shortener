FactoryBot.define do
  factory :url do
    original { Faker::Internet.url('google.com') }
    short { Faker::Internet.url('localhost.com', '/1234') }
    sanitize { Faker::Internet.url('localhost.com', '/12345') }
  end
end
