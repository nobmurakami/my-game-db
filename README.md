# アプリ名
MGDB.JP (エムジーディービードットジェイピー)

# 概要
次にプレイするゲームが見つかる、ゲームの総合データベースアプリです。<br>
ログインすることでゲーム情報の新規登録・編集ができるとともに、マイリスト機能でゲームを管理することができます。

# 本番環境
## URL
https://www.mgdb.jp/

## テスト用アカウント
### ユーザー名
テストユーザー
### Eメール
test@test.com
### パスワード
z4neiy

## 使い方
1. ブラウザで上記URLにアクセスしてください。（Google Chrome推奨）
2. トップページ(詳細検索画面)が表示されたら画面右上の[ログイン]をクリックし、ログイン画面に遷移します。
3. 上記テスト用アカウントでログインします。

- 一覧表示のゲームタイトルをクリックすると、ゲームの詳細表示画面に遷移します。
- ヘッダーのメニューから新しいゲームの追加、マイリスト、マイページへの遷移が可能です。
- 各ゲームに表示されている[お気に入り][プレイ予定][プレイ中][プレイ済み]ボタンを押すとマイリストに追加できます。

# 制作背景（意図）
ゲームが好きな人の、以下のような課題を解決するために制作しました。
- 興味のあるゲームがたくさんあって、覚えておくのが大変。
- とにかく評判のいいゲームをプレイしたい。
- 有名じゃないけど自分の好みに合っているゲームを探したい。
- これまで遊んできたゲームの記録を思い出として残したい。

# 機能
## 詳細検索機能／並び替え機能(ransack)
ヘッダーメニュー > [データベース] > [詳細検索]<br>
様々な条件での絞り込み表示と並び替えが可能です。<br>
![image](https://user-images.githubusercontent.com/76082764/108618286-43510e00-7460-11eb-9f83-c9ebe6dda731.png)

## ゲームの詳細表示
一覧からゲームのタイトルをクリックすると、登録されているゲーム情報が表示されます。<br>
画面右の[編集]ボタンから情報の編集が可能です。（ログイン中のみ）<br>
![image](https://user-images.githubusercontent.com/76082764/108618528-6ed4f800-7462-11eb-8b1d-6d258aa50ceb.png)

## タグ機能／「自分のタグ」機能
ゲーム詳細画面でゲームに「自分のタグ」を設定できます。<br>
各ユーザーが設定したタグは集計され、設定したユーザーが多い順にゲームのタグとして表示されます。<br>
![image](https://user-images.githubusercontent.com/76082764/108627546-7cf23b00-7499-11eb-9883-6a92a72fe9ea.png)

## カテゴリ別一覧表示
ゲーム詳細画面で機種、ジャンル、開発元、パブリッシャー、タグのリンクをクリックするとカテゴリ別一覧表示画面に遷移します。<br>
![image](https://user-images.githubusercontent.com/76082764/108627492-44526180-7499-11eb-8ba6-4981c3674197.png)

## マイリスト
詳細画面や一覧表示に表示されている[お気に入り][プレイ予定][プレイ中][プレイ済み]ボタンを押すと、マイリストにゲームが追加されます。<br>
![image](https://user-images.githubusercontent.com/76082764/108628951-00635a80-74a1-11eb-9667-71819f8e5ac0.png)
![image](https://user-images.githubusercontent.com/76082764/108629223-4d93fc00-74a2-11eb-91ef-c88503166987.png)

## おすすめのゲーム（ヘッダーメニュー > ユーザー名 > [マイページ]）
ゲームを[お気に入り]すると、 マイページに[おすすめのゲーム]が紹介されます。<br>
![image](https://user-images.githubusercontent.com/76082764/108629629-2b02e280-74a4-11eb-9801-b929c2dde025.png)

## ゲーム新規登録機能（ヘッダーメニュー > [データベース] > [ゲームを追加]）
### データベースに存在しないゲームを新たに登録します。
![image](https://user-images.githubusercontent.com/76082764/108630890-8afc8780-74aa-11eb-9b21-38bbf398ca13.png)

### ジャンル、開発元、パブリッシャーはカンマ(,)で区切ることで複数登録可能です。
![image](https://user-images.githubusercontent.com/76082764/108632919-ac627100-74b4-11eb-8b20-ee7871597099.png)
**↓**<br>
![image](https://user-images.githubusercontent.com/76082764/108632980-0cf1ae00-74b5-11eb-9a44-0b542bbaee2f.png)

### Steamからの情報取得
ゲームの情報にSteamのストアページURLを登録すると、Steamからゲーム画像や一部のゲーム情報を取得します。<br>
※ユーザーがアップロードした情報がある場合はそちらが優先して表示されます。<br>
また、ゲーム詳細ページにSteamへのリンクボタンが設置されます。<br>
![image](https://user-images.githubusercontent.com/76082764/108631222-16c2e380-74ac-11eb-8651-d0d2c5660dd3.png)

## YouTube動画埋め込み
ゲームの情報にYouTubeの公式トレイラー動画のURLを登録すると、ゲーム詳細ページに動画を埋め込み表示します。。<br>
![image](https://user-images.githubusercontent.com/76082764/108633640-a1a9db00-74b8-11eb-82ab-73a6816c8c65.png)
![image](https://user-images.githubusercontent.com/76082764/108633608-7f17c200-74b8-11eb-956e-f25057e7f50e.png)

## ユーザー登録／ログイン機能(Devise)
![image](https://user-images.githubusercontent.com/76082764/108633930-5b557b80-74ba-11eb-950c-067b53865cb1.png)
![image](https://user-images.githubusercontent.com/76082764/108633955-70caa580-74ba-11eb-87a3-e70ebdf5825c.png)

## お問合せフォーム（Action Mailer）
フッターのボタンからお問い合わせフォームに遷移します。<br>
本番環境ではフォームを送信するとGmailで指定したアドレスにメールが送信されます。<br>
![image](https://user-images.githubusercontent.com/76082764/108634909-68289e00-74bf-11eb-9aae-a748af509d34.png)

# 工夫したポイント
- 「開発元」と「パブリッシャー」はどちらも会社名を扱うカテゴリーなので、テーブルではなくenumを利用したアソシエーションで区別するようにし、会社名で検索することで「開発元」「パブリッシャー」のどちらにもヒットするようにした。
- [プレイ予定][プレイ中][プレイ済み]のステータスは重複することがないので、既にいずれかのボタンが押されている時に他のボタンを押したら、自動的に元々押されていたボタンが解除されるようにした。（トランザクションを利用）

# 使用技術（開発環境）
## バックエンド
Ruby, Ruby on Rails, Steam Web API

## フロントエンド
Semantic UI, JavaScript, jQuery

## データベース
MySQL, Sequel Pro

## インフラ
AWS(EC2, S3), Capistrano

## Webサーバー（本番環境）
Nginx

## アプリケーションサーバー（本番環境）
unicorn

## ソース管理
GitHub, GitHub Desktop

## テスト
RSpec

## エディタ
VSCode

# 課題・今後実装したい機能
- 管理者機能： データの削除など、重要な操作をサイトの運営者だけができるように。
- ゲーム情報登録時の逐次検索機能： すでにDBに存在するタグやジャンルなどを入力しやすいように。
- 他ユーザーのマイリストの閲覧・検索・おすすめ表示： 自分と好みが似ているユーザーのリストからゲームを探せるように。
- ユーザー情報編集機能
- 発売日&機種の複数登録： 現在、同じゲームタイトルでも発売された機種ごとにバラバラに登録する必要があるので、まとめて管理できるように。
- 複数言語でのタイトル登録： 日本語と英語の両方の表記でタイトルを検索できるように。
- 重複した投稿を防止する仕組み： 登録時に重複に気付けるようにする、重複した記事を報告できたりするようにするなど。
- ゲーム詳細画面へのコメント機能追加： ゲームについてユーザー同士が語り合えるように。
- ユーザーレーティング機能: サイト独自のゲーム評価システム。

# ローカルでの動作方法
## 動作環境
- Ruby 2.6.5
- Rails 6.0.0

## コマンド
$ git clone https://github.com/nobmurakami/my-game-db.git<br>
$ cd my-game-db<br>
$ bundle install<br>
$ yarn install<br>
$ rails db:create<br>
$ rails db:migrate<br>
$ rails s<br>

ブラウザでアクセス：<br>
http://localhost:3000

## お問い合わせフォームの動作確認方法（ローカル）
1. 環境変数`MAIL_TO`に適当なメールアドレスを設定
2. サーバーを終了し、環境変数を反映させてから再起動
3. お問合せフォームを送信
4. http://localhost:3000/letter_opener にアクセス

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
