FactoryBot.define do
  factory :game_form do
    title { Faker::Game.title }
    description { Faker::Lorem.paragraph }
    metascore { Faker::Number.within(range: 1..100) }
    release_date  { Faker::Date.between(from: '1970-01-01', to: '2020-12-31') }
    genre_names { "#{Faker::Game.genre}, #{Faker::Game.genre}" }
    developer_names { "#{Faker::Company.name}, #{Faker::Company.name}" } 
    publisher_names { "#{Faker::Company.name}, #{Faker::Company.name}" } 
    steam { "https://store.steampowered.com/app/489830/The_Elder_Scrolls_V_Skyrim_Special_Edition/" }

    image { 'image' }

    association :platform_name, factory: :platform

    # after(:build) do |game|
    #   item.image.attach(io: File.open('app/assets/images/game-sample.png'), filename: 'game-sample.png')
    # end
  end
end
