class GameForm
  include ActiveModel::Model

  attr_accessor :title, :image, :description, :metascore, :release_date, :platform_name, :tag_names

  def initialize(params = nil, game: Game.new)
    @game = game

    params ||= {
      title: game.title,
      description: game.description,
      metascore: game.metascore,
      release_date: game.release_date,
      platform_name: game.platform.try(:name),
      tag_names: game.tags.pluck(:name).join(',')
    }
    super(params)
  end

  def save
    return if invalid?

    if image.present?
      @game.update(image: image)
    end

    platform = Platform.find_or_create_by(name: platform_name)
    tags = tag_names.split(',').map { |tag| Tag.find_or_create_by(name: tag) }

    @game.update(title: title, description: description, metascore: metascore, release_date: release_date, platform_id: platform.id, tags: tags)
  end

  validates :title, presence: true
  validates :platform_name, presence: true
  validates :metascore, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_blank: true }
end