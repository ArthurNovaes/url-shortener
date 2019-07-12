FactoryBot.define do
  factory :url do
    original { Faker::Internet.url('Google.com') }
    sanitize { sanitize_url(original) }
    short    { generate_short }
  end

end

def sanitize_url(original_url)
  original_url.strip
  sanitize = original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
  sanitize = "http://#{sanitize}"
end

def generate_short
  url = ([*('a'..'z'),*('0'..'9')]).sample(6).join
  old = Url.find_by(short: url)
  return generate_short if old.present?

  url
end
