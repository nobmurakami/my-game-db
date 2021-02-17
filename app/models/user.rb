class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :taggings, dependent: :destroy
  has_many :tagging_games, through: :taggings, source: :game
  has_many :tags, through: :taggings

  has_many :want_lists, -> { where play_status: "want" }, class_name: "List", dependent: :destroy
  has_many :want_games, through: :want_lists, source: :game

  has_many :playing_lists, -> { where play_status: "playing" }, class_name: "List", dependent: :destroy
  has_many :playing_games, through: :playing_lists, source: :game

  has_many :played_lists, -> { where play_status: "played" }, class_name: "List", dependent: :destroy
  has_many :played_games, through: :played_lists, source: :game

  has_many :lists, dependent: :destroy
  has_many :list_games, through: :lists, source: :game

  has_many :favorites, dependent: :destroy
  has_many :favorite_games, through: :favorites, source: :game

  validates :name, presence: true

  def favorited?(game)
    self.favorites.exists?(game_id: game.id)
  end

  def similar_users
    similar_users = []

    self.favorite_games.each do |game|
      game.favorite_users.each do |user|
        similar_users.push(user) unless user == self
      end
    end
    similar_users.uniq
  end

end
