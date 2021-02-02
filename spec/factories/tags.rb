FactoryBot.define do
  factory :tag do
    name { Faker::Game.genre }
  end
end
