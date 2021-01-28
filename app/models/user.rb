class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :taggings, dependent: :destroy
  has_many :tagging_games, through: :taggings, source: :game
  has_many :tags, through: :taggings

  validates :name, presence: true
end
