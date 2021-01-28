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
      @game.update!(developers: developers, publishers: publishers)
      tags.map { |tag| Tagging.find_or_create_by!(game_id: @game.id, tag_id: tag.id, user_id: user_id )}

      if @game.steam.present?
        steam_data
        @game.update!(steam_image: @steam_image)
        @game.update!(description: @steam_description) if @game.description.blank?
        @game.update!(metascore: @steam_metascore) if @game.metascore.blank?
        @game.update!(release_date: @steam_release_date) if @game.release_date.blank?
        @game.update!(genres: @steam_genres) if @game.genres.blank?
        @game.update!(developers: @steam_developers) if @game.developers.blank?
        @game.update!(publishers: @steam_publishers) if @game.publishers.blank?

        tags = @steam_genres.map { |genre| Tag.find_or_create_by!(name: genre.name) }
        tags.map { |tag| Tagging.find_or_create_by!(game_id: @game.id, tag_id: tag.id, user_id: user_id )}
      end
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

  def steam_data
    json = steam_json
    if json[steam_appids]["success"] == true
      @steam_image = json[steam_appids]["data"]["header_image"]
      @steam_description = json[steam_appids]["data"]["short_description"]
      @steam_metascore = json[steam_appids]["data"]["metacritic"]["score"]
      @steam_release_date = Date.strptime(json[steam_appids]["data"]["release_date"]["date"], '%Y年%m月%d日')
      @steam_genres = json[steam_appids]["data"]["genres"].map { |genre| Genre.find_or_create_by!(name: genre["description"]) }
      @steam_developers = json[steam_appids]["data"]["developers"].map { |dev| Company.find_or_create_by!(name: dev) }
      @steam_publishers = json[steam_appids]["data"]["publishers"].map { |pub| Company.find_or_create_by!(name: pub) }
    end
  end
end
