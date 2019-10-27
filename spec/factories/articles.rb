FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: Random.new.rand(5..50)) }
    body { Faker::Lorem.sentences }
    user
  end
end
