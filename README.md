# アプリ名
My Game DB （マイゲームディービー）

# 概要

# 本番環境

# 制作背景（意図）

# DEMO

# 工夫したポイント

# 使用技術（開発環境）

# 課題・今後実装したい機能

# DB設計

## ER図
![erd](https://user-images.githubusercontent.com/76082764/108616414-84d9bd00-7450-11eb-87ac-e42ff2852b29.png)

## games テーブル

| Column         | Type       | Options           |
| -------------- | ---------- | ----------------- |
| title          | string     | null: false       |
| description    | text       |                   |
| metascore      | integer    |                   |
| release_date   | date       |                   |
| platform       | references | foreign_key: true |
| steam          | string     |                   |
| steam_image    | string     |                   |
| youtube        | string     |                   |
| favorite_count | integer    | null: false       |

### Association

- has_one_attached :image
- belongs_to :platform
- has_many :game_genres, dependent: :destroy
- has_many :genres, through: :game_genres
- has_many :game_companies, dependent: :destroy
- has_many :companies, through: :game_companies
- has_many :developer_game_companies, -> {where(type: 'developer')}, class_name: 'GameCompany'
- has_many :developers, through: :developer_game_companies, source: :company
- has_many :publisher_game_companies, -> {where(type: 'publisher')}, class_name: 'GameCompany'
- has_many :publishers, through: :publisher_game_companies, source: :company
- has_many :taggings, dependent: :destroy
- has_many :tags, through: :taggings
- has_many :want_lists, -> { where play_status: 'want' }, class_name: 'List', dependent: :destroy
- has_many :want_users, through: :want_lists, source: :user
- has_many :playing_lists, -> { where play_status: 'playing' }, class_name: 'List', dependent: :destroy
- has_many :playing_users, through: :playing_lists, source: :user
- has_many :played_lists, -> { where play_status: 'played' }, class_name: 'List', dependent: :destroy
- has_many :played_users, through: :played_lists, source: :user
- has_many :lists, dependent: :destroy
- has_many :list_users, through: :lists, source: :user
- has_many :favorites, dependent: :destroy
- has_many :favorite_users, through: :favorites, source: :user

## platforms テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :games

## game_genres テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| game   | references | null: false, foreign_key: true |
| genre  | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :genre

## genres テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :game_genres, dependent: :destroy
- has_many :games, through: :game_genres

## game_companies テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| game         | references | null: false, foreign_key: true |
| company      | references | null: false, foreign_key: true |
| company_type | integer    | null: false                    |

### Association

- belongs_to :game
- belongs_to :company

### Notes

- enum company_type: { developer: 0, publisher: 1 }

## companies テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :game_companies, dependent: :destroy
- has_many :games, through: :game_companies

## taggings テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| game   | references | null: false, foreign_key: true |
| tag    | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :tag
- belongs_to :user

## tags テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :taggings, dependent: :destroy
- has_many :games, through: :taggings

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| name               | string | null: false |
| email              | string | null: false |
| encrypted_password | string | null: false |

### Association

- has_many :taggings, dependent: :destroy
- has_many :tagging_games, through: :taggings, source: :game
- has_many :tags, through: :taggings
- has_many :want_lists, -> { where play_status: 'want' }, class_name: 'List', dependent: :destroy
- has_many :want_games, through: :want_lists, source: :game
- has_many :playing_lists, -> { where play_status: 'playing' }, class_name: 'List', dependent: :destroy
- has_many :playing_games, through: :playing_lists, source: :game
- has_many :played_lists, -> { where play_status: 'played' }, class_name: 'List', dependent: :destroy
- has_many :played_games, through: :played_lists, source: :game
- has_many :lists, dependent: :destroy
- has_many :list_games, through: :lists, source: :game
- has_many :favorites, dependent: :destroy
- has_many :favorite_games, through: :favorites, source: :game

## lists テーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| user        | references | null: false, foreign_key: true |
| game        | references | null: false, foreign_key: true |
| play_status | integer    | null: false                    |

### Association

- belongs_to :user
- belongs_to :game

### Notes

- enum play_status: { want: 0, playing: 1, played: 2 }

## favorites テーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| user        | references | null: false, foreign_key: true |
| game        | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :game, counter_cache: true

## contacts テーブル

| Column  | Type   | Options     |
| ------- | ------ | ----------- |
| name    | string | null: false |
| email   | string | null: false |
| message | text   | null: false |