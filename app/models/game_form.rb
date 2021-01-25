class GameForm
  include ActiveModel::Model

  attr_accessor :title, :image, :description, :metascore, :release_date, :platform_name, :region_name

  def initialize(params = nil, game: Game.new)
    binding.pry
    @game = game

    params ||= {
      title: game.title,
      image: game.image,
      description: game.description,
      metascore: game.metascore,
      release_date: game.release_date,
      platform_name: game.platform.try(:name),
      region_name: game.region.try(:name) 
    }
    super(params)
  end

  def save
    return if invalid?

    platform = Platform.find_or_create_by(name: platform_name)
    region = Region.find_or_create_by(name: region_name)

    @game.update(title: title, image: image, description: description, metascore: metascore, release_date: release_date, platform_id: platform.id, region_id: region.id)
  end
end