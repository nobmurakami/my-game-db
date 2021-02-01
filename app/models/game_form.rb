class GameForm
  include ActiveModel::Model

  attr_accessor :title, :image, :description, :metascore, :release_date, :platform_name, :genre_names,
                :developer_names, :publisher_names, :user_id, :steam, :steam_image

  def initialize(params = nil, game: Game.new)
    @game = game

    params ||= {
      title: game.title,
      description: game.description,
      metascore: game.metascore,
      release_date: game.release_date,
      platform_name: game.platform.try(:name),
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

      platform = Platform.find_or_create_by!(name: platform_name.strip_all_space)
      genres = genre_names.split(',').map { |genre| Genre.find_or_create_by!(name: genre.strip_all_space) }
      tags = genres.map { |genre| Tag.find_or_create_by!(name: genre.name) }
      developers = developer_names.split(',').map { |dev| Company.find_or_create_by!(name: dev.strip_all_space) }
      publishers = publisher_names.split(',').map { |pub| Company.find_or_create_by!(name: pub.strip_all_space) }

      @game.update!(title: title.strip_all_space, description: description.strip_all_space, metascore: metascore, release_date: release_date,
                    platform_id: platform.id, genres: genres, steam: steam)
      @game.update!(developers: developers, publishers: publishers)

      if @game.steam.present? && steam_data
        @game.update!(steam_image: @steam_image)
        @game.update!(description: @steam_description) if @game.description.blank?
        @game.update!(metascore: @steam_metascore) if @game.metascore.blank?
        @game.update!(release_date: @steam_release_date) if @game.release_date.blank?
        @game.update!(genres: @steam_genres) if @game.genres.blank?
        @game.update!(developers: @steam_developers) if @game.developers.blank?
        @game.update!(publishers: @steam_publishers) if @game.publishers.blank?

        tags = @steam_genres.map { |genre| Tag.find_or_create_by!(name: genre.name) }
        tags.map { |tag| Tagging.find_or_create_by!(game_id: @game.id, tag_id: tag.id, user_id: user_id )}
      else
        @game.update!(steam: '')
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
  VALID_STEAM_URL = /\Ahttps:\/\/store\.steampowered\.com\/app\/\d+.+/
  validates :steam, format: { with: VALID_STEAM_URL }

  private

  def steam_json
    url = "https://store.steampowered.com/api/appdetails?l=japanese&appids=#{steam_appids}"
    response = OpenURI.open_uri(url)
    ActiveSupport::JSON.decode(response.read)
  end

  def steam_data
    if steam_json.dig(steam_appids, "success") == true
      json = steam_json[steam_appids]["data"] 
      @steam_image = json.dig("header_image")
      @steam_description = json.dig("short_description")
      @steam_metascore = json.dig("metacritic", "score")
      @steam_release_date = Date.strptime(json.dig("release_date", "date"), '%Y年%m月%d日')
      @steam_genres = json.dig("genres").map { |genre| Genre.find_or_create_by!(name: genre["description"]) }
      @steam_developers = json.dig("developers").map { |dev| Company.find_or_create_by!(name: dev) }
      @steam_publishers = json.dig("publishers").map { |pub| Company.find_or_create_by!(name: pub) }
    end
  end
end
