FactoryBot.define do
  factory :genre do
    name { Faker::Game.genre }
  end
end
