require 'rails_helper'

RSpec.describe "ゲーム新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @game = FactoryBot.build(:game_form)
  end
  
  context '登録に成功したとき' do
    it 'ゲームの登録に成功すると、ゲーム一覧に遷移して、登録したゲームが表示されている' do
      # サインインする
      sign_in(@user)

      # ゲーム新規登録画面に遷移する
      visit new_game_path
      expect(current_path).to eq new_game_path

      # 最低限の項目だけ入力してゲームを登録する
      fill_in 'game_form_title', with: @game.title
      fill_in 'game_form_platform_name', with: @game.platform_name
      expect {
        click_on("Create Game")
      }.to change { Game.count }.by(1)
      expect(current_path).to eq root_path

      # 登録したゲームが表示されている
      expect(page).to have_content(@game.title)
      expect(page).to have_content(@game.platform_name)
    end

    it 'Steam以外の全ての項目を入力してゲームを登録すると、ゲーム一覧と詳細ページに入力した内容が表示されている' do
      # サインインする
      sign_in(@user)

      # ゲーム新規登録画面に遷移する
      visit new_game_path
      expect(current_path).to eq new_game_path

      # 全ての項目を入力してゲームを登録する
      fill_in 'game_form_title', with: @game.title
      fill_in 'game_form_platform_name', with: @game.platform_name
      image_path = Rails.root.join('public/images/game_sample.png')
      attach_file('game_form_image', image_path)
      fill_in 'game_form_description', with: @game.description
      fill_in 'game_form_metascore', with: @game.metascore
      fill_in 'game_form_release_date', with: @game.release_date
      fill_in 'game_form_genre_names', with: @game.genre_names
      fill_in 'game_form_developer_names', with: @game.developer_names
      fill_in 'game_form_publisher_names', with: @game.publisher_names

      expect {
        click_on("Create Game")
      }.to change { Game.count }.by(1)
      expect(current_path).to eq root_path

      # ゲーム一覧に入力した内容が表示されている
      expect(page).to have_content(@game.title)
      expect(page).to have_content(@game.platform_name)
      expect(page).to have_selector("img[src$='game_sample.png']")
      expect(page).to have_content("Metascore: #{@game.metascore}")
      expect(page).to have_content(@game.release_date)

      # ゲーム詳細ページに入力した内容が表示されている
      click_on(@game.title)
      expect(current_path).to eq game_path(Game.first)
      expect(page).to have_content(@game.title)
      expect(page).to have_content(@game.platform_name)
      expect(page).to have_selector("img[src$='game_sample.png']")
      expect(page).to have_content(@game.metascore)
      expect(page).to have_content(@game.release_date)
      expect(page).to have_content(@game.description)
      expect(page).to have_content(@game.genre_names)
      expect(page).to have_content(@game.developer_names)
      expect(page).to have_content(@game.publisher_names)
    end
  end

  context '登録に失敗したとき' do
    it 'タイトルを入力しないと登録に失敗する' do
      # サインインする
      sign_in(@user)

      # ゲーム新規登録画面に遷移する
      visit new_game_path
      expect(current_path).to eq new_game_path

      # タイトル以外の項目を入力する
      fill_in 'game_form_platform_name', with: @game.platform_name
      image_path = Rails.root.join('public/images/game_sample.png')
      attach_file('game_form_image', image_path)
      fill_in 'game_form_description', with: @game.description
      fill_in 'game_form_metascore', with: @game.metascore
      fill_in 'game_form_release_date', with: @game.release_date
      fill_in 'game_form_genre_names', with: @game.genre_names
      fill_in 'game_form_developer_names', with: @game.developer_names
      fill_in 'game_form_publisher_names', with: @game.publisher_names

      # 登録ボタンを押してもDBに保存されない
      expect {
        click_on("Create Game")
      }.not_to change { Game.count }

      # 元のページに戻ってくる
      expect(current_path).to eq "/games"
      
      # エラーメッセージが表示されていることを確認
      expect(page).to have_content("Title can't be blank")
    end

    it '機種を入力しないと登録に失敗する' do
      # サインインする
      sign_in(@user)

      # ゲーム新規登録画面に遷移する
      visit new_game_path
      expect(current_path).to eq new_game_path

      # 機種以外の項目を入力する
      fill_in 'game_form_title', with: @game.title
      image_path = Rails.root.join('public/images/game_sample.png')
      attach_file('game_form_image', image_path)
      fill_in 'game_form_description', with: @game.description
      fill_in 'game_form_metascore', with: @game.metascore
      fill_in 'game_form_release_date', with: @game.release_date
      fill_in 'game_form_genre_names', with: @game.genre_names
      fill_in 'game_form_developer_names', with: @game.developer_names
      fill_in 'game_form_publisher_names', with: @game.publisher_names

      # 登録ボタンを押してもDBに保存されないことを確認
      expect {
        click_on("Create Game")
      }.not_to change { Game.count }

      # 元のページに戻ってくることを確認
      expect(current_path).to eq "/games"
      
      # エラーメッセージが表示されていることを確認
      expect(page).to have_content("Platform name can't be blank")
    end
  end
end

RSpec.describe "ゲームの更新", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @tagging_user1 = FactoryBot.create(:user)
    @tagging_user2 = FactoryBot.create(:user)
    @game = FactoryBot.build(:game)
    @game.taggings[0].user = @tagging_user1
    @game.taggings[1].user = @tagging_user2
    @game.developer_game_companies[0].game = @game
    @game.developer_game_companies[1].game = @game
    @game.publisher_game_companies[0].game = @game
    @game.publisher_game_companies[1].game = @game
    @game.save
    @edit = FactoryBot.build(:game_form)
  end
  
  context '更新に成功したとき' do
    it 'ゲームの更新に成功すると、ゲーム詳細ページに遷移して、更新した内容が表示されている' do
      # サインインする
      sign_in(@user)

      # ゲーム詳細ページに遷移する
      click_on(@game.title)
      expect(current_path).to eq game_path(@game)

      # ゲーム編集ページに遷移する
      click_on('Edit')
      expect(current_path).to eq edit_game_path(@game)

      # 全ての項目を書き換える
      fill_in 'game_form_title', with: ''
      fill_in 'game_form_title', with: @edit.title
      fill_in 'game_form_platform_name', with: ''
      fill_in 'game_form_platform_name', with: @edit.platform_name
      image_path = Rails.root.join('public/images/game_sample2.png')
      attach_file('game_form_image', image_path)
      fill_in 'game_form_description', with: ''
      fill_in 'game_form_description', with: @edit.description
      fill_in 'game_form_metascore', with: ''
      fill_in 'game_form_metascore', with: @edit.metascore
      fill_in 'game_form_release_date', with: ''
      fill_in 'game_form_release_date', with: @edit.release_date
      fill_in 'game_form_genre_names', with: ''
      fill_in 'game_form_genre_names', with: @edit.genre_names
      fill_in 'game_form_developer_names', with: ''
      fill_in 'game_form_developer_names', with: @edit.developer_names
      fill_in 'game_form_publisher_names', with: ''
      fill_in 'game_form_publisher_names', with: @edit.publisher_names

      # フォームを送信するとゲーム詳細ページに遷移する
      click_on("Update Game")
      expect(current_path).to eq game_path(@game)

      # ゲーム詳細ページに更新した内容が表示されている
      expect(page).to have_content(@edit.title)
      expect(page).to have_content(@edit.platform_name)
      expect(page).to have_selector("img[src$='game_sample2.png']")
      expect(page).to have_content(@edit.metascore)
      expect(page).to have_content(@edit.release_date)
      expect(page).to have_content(@edit.description)
      expect(page).to have_content(@edit.genre_names)
      expect(page).to have_content(@edit.developer_names)
      expect(page).to have_content(@edit.publisher_names)
    end

    it '何も編集せずに更新しても元のデータが消えない' do
      # サインインする
      sign_in(@user)

      # ゲーム詳細ページに遷移する
      click_on(@game.title)
      expect(current_path).to eq game_path(@game)

      # ゲーム編集ページに遷移する
      click_on('Edit')
      expect(current_path).to eq edit_game_path(@game)

      # 編集せずにフォームを送信する
      click_on("Update Game")
      expect(current_path).to eq game_path(@game)

      # ゲーム詳細ページに元の内容が表示されている
      expect(page).to have_content(@game.title)
      expect(page).to have_content(@game.platform.name)
      expect(page).to have_selector("img[src$='game_sample.png']")
      expect(page).to have_content(@game.metascore)
      expect(page).to have_content(@game.release_date)
      expect(page).to have_content(@game.description)
      expect(page).to have_content(@game.genres[0].name)
      expect(page).to have_content(@game.genres[1].name)
      expect(page).to have_content(@game.developers[0].name)
      expect(page).to have_content(@game.developers[1].name)
      expect(page).to have_content(@game.publishers[0].name)
      expect(page).to have_content(@game.publishers[1].name)
    end
  end

  context '更新に失敗したとき' do
    it 'タイトルを入力しないと更新に失敗する' do
      # サインインする
      sign_in(@user)

      # ゲーム詳細ページに遷移する
      click_on(@game.title)
      expect(current_path).to eq game_path(@game)

      # ゲーム編集ページに遷移する
      click_on('Edit')
      expect(current_path).to eq edit_game_path(@game)

      # 入力されているタイトルを消してフォーム送信
      fill_in 'game_form_title', with: ''
      click_on("Update Game")
     
      # 元のページに戻されてエラーメッセージが表示される
      expect(current_path).to eq "/games/#{@game.id}"
      expect(page).to have_content("Title can't be blank")
    end

    it '機種を入力しないと更新に失敗する' do
      # サインインする
      sign_in(@user)

      # ゲーム詳細ページに遷移する
      click_on(@game.title)
      expect(current_path).to eq game_path(@game)

      # ゲーム編集ページに遷移する
      click_on('Edit')
      expect(current_path).to eq edit_game_path(@game)

      # 入力されている機種を消してフォーム送信
      fill_in 'game_form_platform_name', with: ''
      click_on("Update Game")
     
      # 元のページに戻されてエラーメッセージが表示される
      expect(current_path).to eq "/games/#{@game.id}"
      expect(page).to have_content("Platform name can't be blank")
    end
  end
end