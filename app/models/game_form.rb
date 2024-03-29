class GameForm
  include ActiveModel::Model

  attr_accessor :title, :image, :description, :metascore, :release_date, :platform_name, :genre_names,
                :developer_names, :publisher_names, :user_id, :steam, :steam_image, :youtube

  def initialize(params = nil, game: Game.new)
    @game = game

    params ||= {
      title: game.title,
      description: game.description,
      metascore: game.metascore,
      release_date: game.release_date,
      platform_name: game.platform.try(:name),
      genre_names: game.genres.pluck(:name).join(", "),
      developer_names: game.developers.pluck(:name).join(", "),
      publisher_names: game.publishers.pluck(:name).join(", "),
      steam: game.steam,
      youtube: game.youtube
    }
    super(params)
  end

  def save
    ActiveRecord::Base.transaction do
      platform = Platform.find_or_create_by!(name: platform_name.strip_all_space)
      genres = split_and_delete_space(genre_names).map { |genre| Genre.find_or_create_by!(name: genre) }
      developers = split_and_delete_space(developer_names).map { |dev| Company.find_or_create_by!(name: dev) }
      publishers = split_and_delete_space(publisher_names).map { |pub| Company.find_or_create_by!(name: pub) }

      @game.update!(title: title.strip_all_space, description: description.strip_all_space, metascore: metascore,
                    release_date: release_date, platform_id: platform.id, genres: genres, steam: steam, youtube: youtube)
      @game.update!(developers: developers, publishers: publishers)

      # フォームで画像が選択されている場合のみ、画像を更新する。（編集時に元の画像を消さないため）
      @game.update!(image: image) if image.present?

      if @game.steam.present? && steam_data
        @game.update!(steam_image: @steam_image)
        @game.update!(metascore: @steam_metascore) if @game.metascore.blank?
        @game.update!(release_date: @steam_release_date) if @game.release_date.blank?
        @game.update!(genres: @steam_genres) if @game.genres.blank?
        @game.update!(developers: @steam_developers) if @game.developers.blank?
        @game.update!(publishers: @steam_publishers) if @game.publishers.blank?
      else
        @game.update!(steam: "")
      end
    end

    return @game
  end

  validates :title, presence: true
  validates :platform_name, presence: true
  validates :metascore,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_blank: true }
  VALID_STEAM_URL = %r{\Ahttps://store\.steampowered\.com/app/\d+.+}.freeze
  validates :steam, format: { with: VALID_STEAM_URL, allow_blank: true }

  private

  def steam_appids
    @game.steam.split("/")[4]
  end

  def steam_json
    url = "https://store.steampowered.com/api/appdetails?l=japanese&appids=#{steam_appids}"
    response = OpenURI.open_uri(url).read
    # 日本語の情報が存在しなかったら英語の情報を見る
    if response.empty?
      url = "https://store.steampowered.com/api/appdetails?appids=#{steam_appids}"
      response = OpenURI.open_uri(url).read
    end

    ActiveSupport::JSON.decode(response)
  end

  def steam_data
    return unless steam_json.dig(steam_appids, "success") == true

    json = steam_json[steam_appids]["data"]
    @steam_image = json["header_image"]
    @steam_metascore = json.dig("metacritic", "score")

    # ゲームによって日付の書式が異なるので一旦コメントアウト
    # release_date = json.dig("release_date", "date")
    # @steam_release_date = Date.strptime(release_date, '%Y年%m月%d日')

    @steam_genres = json["genres"].map { |genre| Genre.find_or_create_by!(name: genre["description"]) }
    @steam_developers = json["developers"].map { |dev| Company.find_or_create_by!(name: dev) }
    @steam_publishers = json["publishers"].map { |pub| Company.find_or_create_by!(name: pub) }
  end

  def split_and_delete_space(str)
    str.split(",").grep(/[^[:space:]]/).map(&:strip_all_space)
  end
end
