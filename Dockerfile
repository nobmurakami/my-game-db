# Railsコンテナ用Dockerfile

# イメージのベースラインにRuby2.6.5を指定
FROM ruby:2.6.5
# Railsに必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y mariadb-client nodejs vim --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
# ルートディレクトリを作成
RUN mkdir /myproject
# 作業ディレクトリを指定
WORKDIR /myproject
# ローカルのGemfileとGemfile.lockをコピー
COPY Gemfile /myproject/Gemfile
COPY Gemfile.lock /myproject/Gemfile.lock
# Gemのインストール実行
RUN gem install bundler
RUN bundle install
# ローカルのsrcをコピー
COPY . /myproject