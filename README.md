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

| Column      | Type    | Options     |
| ----------- | ------- | ----------- |
| title       | string  | null: false |
| description | text    |             |
| metascore   | integer |             |

### Association

- has_many :game_genres
- has_many :game_themes
- has_many :game_keywords
- has_many :releases, dependent: :destroy
- has_many :lists, dependent: :destroy
- has_many :genres, through: :game_genres
- has_many :themes, through: :game_themes
- has_many :keywords, through: :game_keywords
- has_many :platforms, through: :releases
- has_many :regions, through: :releases

## releases テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| game     | references | null: false, foreign_key: true |
| platform | references | null: false, foreign_key: true |
| region   | references | null: false, foreign_key: true |
| date     | date       |                                |

### Association

- belongs_to :game
- belongs_to :platform
- belongs_to :region

## platforms テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

### Association

- has_many :releases
- has_many :games, through: :releases

## regions テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

### Association

- has_many :releases
- has_many :games, through: :releases

## game_genres テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| game   | references | null: false, foreign_key: true |
| genre  | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :genre

## genres テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

### Association

- has_many :game_genres
- has_many :games, through: :game_genres

## game_themes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| game   | references | null: false, foreign_key: true |
| theme  | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :theme

## themes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

### Association

- has_many :game_themes
- has_many :games, through: :game_themes

## game_keywords テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| game    | references | null: false, foreign_key: true |
| keyword | references | null: false, foreign_key: true |

### Association

- belongs_to :game
- belongs_to :keyword

## keywords テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| name   | references | null: false, foreign_key: true |

### Association

- has_many :game_keywords
- has_many :games, through: :game_keywords
