# アプリ名
My Game DB （マイゲームディービー）

# 概要
あらゆるゲームの情報を扱う、ゲームの総合データベースアプリです。
ログインすることでマイリスト機能やおすすめのゲーム機能、ゲーム情報の新規登録・編集機能を使用できます。

- マイリスト機能： 登録されているゲームを、「お気に入り」「プレイ予定」「プレイ中」「プレイ済み」のリストに追加して管理できる機能です。
- おすすめのゲーム機能： 自分と好みが似ている他のユーザーが好きなゲームを紹介します。

# 本番環境
## URL
http://13.113.211.12/

## BASIC認証
### ユーザー名
admin
### パスワード
9cDYuWfJ6%Fm

## テスト用アカウント
### Eメール
test@test.com
### パスワード
z4neiy

## 使い方
1. Google Chromeで上記URLにアクセスしてください。
2. 認証ダイアログが表示されたら、上記BASIC認証のユーザー名とパスワードを入力してログインをクリックします。
3. トップページ(詳細検索画面)が表示されたら画面右上の[ログイン]をクリックし、ログイン画面に遷移します。
4. 上記テスト用アカウントでログインします。

- 一覧表示のゲームタイトルをクリックすると、ゲームの詳細表示画面に遷移します。
- ヘッダーのメニューから新しいゲームの追加、マイリスト、マイページへの遷移が可能です。
- 各ゲームに表示されている


ヘッダーのメニューから以下の画面に遷移できます。

- 

トップページの詳細検索画面では、既に登録されているゲームを様々な条件で絞り込んで一覧表示できます。メタスコア（レビュー収集サイト「Metacritic」によるゲームの点数）などでの並び替えも可能です。
- 一覧表示のゲームタイトルをクリックすると、ゲームの詳細表示画面に遷移します。

- ヘッダーメニュー > [データベース] > [ゲームを追加] からゲーム情報を新たに追加することができます。


# 制作背景（意図）
ゲームが好きな人の、以下のような課題を解決するために制作しました。
- 興味のあるゲームがたくさんあって、覚えておくのが大変。
- とにかく評判のいいゲームをプレイしたい。
- 有名じゃないけど自分の好みに合っているゲームを探したい。
- これまで遊んできたゲームの記録を思い出として残したい。

# DEMO
## 詳細検索機能（ヘッダーメニュー > [データベース] > [詳細検索]）
様々な条件での絞り込み表示と並び替えが可能です。
![image](https://user-images.githubusercontent.com/76082764/108618286-43510e00-7460-11eb-9f83-c9ebe6dda731.png)

## ゲームの詳細表示
一覧からゲームのタイトルをクリックすると、登録されているゲーム情報が表示されます。
![image](https://user-images.githubusercontent.com/76082764/108618528-6ed4f800-7462-11eb-8b1d-6d258aa50ceb.png)


## マイリスト


## Steamからの情報取得

## 


# 工夫したポイント

# 使用技術（開発環境）

# 課題・今後実装したい機能



# ローカルでの動作方法
## 動作環境
- Ruby 2.6.5
- Rails 6.0.0

## コマンド
$ git clone https://github.com/nobmurakami/my-game-db.git
$ cd my-game-db
$ bundle install
$ yarn install
$ rails db:create
$ rails db:migrate
$ rails s

ブラウザで以下にアクセス：
http://localhost:3000

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