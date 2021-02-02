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