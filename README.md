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

- has_many :game_genres
- has_many :developers
- has_many :publishers
- has_many :taggings, dependent: :destroy
- has_many :lists, dependent: :destroy
- has_many :genres, through: :game_genres
- has_many :tags, through: :taggings
- belongs_to :platform

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

## developers テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| game    | references | null: false, foreign_key: true |
| company | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :company

## publishers テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| game    | references | null: false, foreign_key: true |
| company | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :company

## companies テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :developers
- has_many :games, through: :developers
- has_many :publishers
- has_many :games, through: :publishers

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
