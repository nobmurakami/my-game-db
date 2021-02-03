FactoryBot.define do
  factory :game do
    title { Faker::Game.title }
    description { Faker::Lorem.paragraph }
    metascore { Faker::Number.within(range: 1..100) }
    release_date  { Faker::Date.between(from: '1970-01-01', to: '2020-12-31') }
    steam_image { 'https://cdn.cloudflare.steamstatic.com/steam/apps/400/header.jpg?t=1608593358' }

    association :platform

    after(:build) do |game|
      game.image.attach(io: File.open('public/images/game_sample.png'), filename: 'game_sample.png')
      game.genres << FactoryBot.build(:genre)
      game.genres << FactoryBot.build(:genre, name: "2nd GENRE")
      game.developers << FactoryBot.build(:company)
      game.developers << FactoryBot.build(:company, name: "2nd DEVELOPER")
      game.publishers << FactoryBot.build(:company)
      game.publishers << FactoryBot.build(:company, name: "2nd PUBLISHER")
      game.developer_game_companies[0].game = game
      game.developer_game_companies[1].game = game
      game.publisher_game_companies[0].game = game
      game.publisher_game_companies[1].game = game
    end
  end
end