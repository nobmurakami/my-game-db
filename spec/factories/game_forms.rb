FactoryBot.define do
  factory :game_form do
    title { Faker::Game.title }
    platform_name { Faker::Game.platform }
    description { Faker::Lorem.paragraph }
    metascore { Faker::Number.within(range: 1..100) }
    release_date  { Faker::Date.between(from: '1970-01-01', to: '2020-12-31') }
    genre_names { "#{Faker::Game.genre}, #{Faker::Game.genre}" }
    developer_names { "#{Faker::Company.name}, #{Faker::Company.name}" } 
    publisher_names { "#{Faker::Company.name}, #{Faker::Company.name}" } 
    steam { "https://store.steampowered.com/app/489830/The_Elder_Scrolls_V_Skyrim_Special_Edition/" }
  end
end
