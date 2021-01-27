# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| name               | string | null: false |
| email              | string | null: false |
| encrypted_password | string | null: false |

### Association

- has_many :lists, dependent: :destroy
- has_many :games, through: :lists
- has_many :taggings, dependent: :destroy
- has_many :tagging_games, through: :taggings, source: :game

## lists テーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| user        | references | null: false, foreign_key: true |
| game        | references | null: false, foreign_key: true |
| play_status | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :game
- belongs_to :play_status

## play_status テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

## games テーブル

| Column       | Type       | Options           |
| ------------ | ---------- | ----------------- |
| title        | string     | null: false       |
| description  | text       |                   |
| metascore    | integer    |                   |
| release_date | date       |                   |
| platform     | references | foreign_key: true |

### Association

- has_one_attached :image
- belongs_to :platform

- has_many :game_genres
- has_many :genres, through: :game_genres

- has_many :taggings, dependent: :destroy
- has_many :tags, through: :taggings

- has_many :lists, dependent: :destroy

- has_many :game_companies
- has_many :companies, through: :game_companies

- has_many :developer_game_companies, -> {where(type: 'developer')}, class_name: 'GameCompany'
- has_many :developers, through: :developer_game_companies, source: :company

- has_many :publisher_game_companies, -> {where(type: 'publisher')}, class_name: 'GameCompany'
- has_many :publishers, through: :publisher_game_companies, source: :company

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

- has_many :game_genres
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

- enum type: { developer: 0, publisher: 1 }

## companies テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :game_companies
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

- has_many :taggings
- has_many :games, through: :taggings
