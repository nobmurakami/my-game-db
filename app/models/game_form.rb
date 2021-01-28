class GameForm
  include ActiveModel::Model

  attr_accessor :title, :image, :description, :metascore, :release_date, :platform_name, :tag_names, :genre_names,
                :developer_names, :publisher_names, :user_id, :steam, :steam_image

  def initialize(params = nil, game: Game.new)
    @game = game

    params ||= {
      title: game.title,
      description: game.description,
      metascore: game.metascore,
      release_date: game.release_date,
      platform_name: game.platform.try(:name),
      tag_names: game.tags.pluck(:name).join(','),
      genre_names: game.genres.pluck(:name).join(','),
      developer_names: game.developers.pluck(:name).join(','),
      publisher_names: game.publishers.pluck(:name).join(','),
      steam: game.steam
    }
    super(params)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      @game.update!(image: image) if image.present?

      platform = Platform.find_or_create_by!(name: platform_name)
      tags = tag_names.split(',').map { |tag| Tag.find_or_create_by!(name: tag) }
      genres = genre_names.split(',').map { |genre| Genre.find_or_create_by!(name: genre) }
      developers = developer_names.split(',').map { |dev| Company.find_or_create_by!(name: dev) }
      publishers = publisher_names.split(',').map { |pub| Company.find_or_create_by!(name: pub) }

      @game.update!(title: title, description: description, metascore: metascore, release_date: release_date,
                    platform_id: platform.id, genres: genres, steam: steam)
      @game.update!(steam_image: steam_image) if @game.steam.present?
      @game.update!(developers: developers, publishers: publishers)
      tags.map { |tag| Tagging.find_or_create_by!(game_id: @game.id, tag_id: tag.id, user_id: user_id )}
    end
  end

  def steam_appids
    @game.steam.split('/')[4]
  end

  validates :title, presence: true
  validates :platform_name, presence: true
  validates :metascore,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_blank: true }

  private

  def steam_json
    url = "https://store.steampowered.com/api/appdetails?l=japanese&appids=#{steam_appids}"
    response = OpenURI.open_uri(url)
    ActiveSupport::JSON.decode(response.read)
  end

  def steam_image
    if steam_json[steam_appids]["success"] == true
      steam_json[steam_appids]["data"]["header_image"]
    end
  end
end
