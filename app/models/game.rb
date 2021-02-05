class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres

  has_many :game_companies, dependent: :destroy
  has_many :companies, through: :game_companies

  has_many :developer_game_companies, -> { where(company_type: "developer") }, class_name: "GameCompany"
  has_many :developers, through: :developer_game_companies, source: :company

  has_many :publisher_game_companies, -> { where(company_type: "publisher") }, class_name: "GameCompany"
  has_many :publishers, through: :publisher_game_companies, source: :company

  has_many :want_lists, -> { where play_status: "want" }, class_name: "PlayList", dependent: :destroy
  has_many :want_users, through: :want_lists, source: :user

  has_many :playing_lists, -> { where play_status: "playing" }, class_name: "PlayList", dependent: :destroy
  has_many :playing_users, through: :playing_lists, source: :user

  has_many :played_lists, -> { where play_status: "played" }, class_name: "PlayList", dependent: :destroy
  has_many :played_users, through: :played_lists, source: :user

  has_many :play_lists, dependent: :destroy
  has_many :play_users, through: :play_lists, source: :user

  def is_wanted_by?(user)
    want_users.where(id: user.id).exists?
  end

  def is_playing_by?(user)
    playing_users.where(id: user.id).exists?
  end

  def was_played_by?(user)
    played_users.where(id: user.id).exists?
  end

  def is_listed_by?(user)
    play_users.where(id: user.id).exists?
  end
end
