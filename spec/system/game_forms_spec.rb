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

      # ゲームを登録する
      visit new_game_path
      expect(current_path).to eq new_game_path
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

    it '全ての項目を入力してゲームの登録に成功すると、ゲーム詳細ページに入力した内容が表示されている' do
      # サインインする
      sign_in(@user)

      # ゲームを登録する
      visit new_game_path
      expect(current_path).to eq new_game_path
      fill_in 'game_form_title', with: @game.title
      fill_in 'game_form_platform_name', with: @game.platform_name
      image_path = Rails.root.join('public/images/game_sample.png')
      attach_file('game_form_image', image_path)

      expect {
        click_on("Create Game")
      }.to change { Game.count }.by(1)
      expect(current_path).to eq root_path

      # 登録したゲームが表示されている
      expect(page).to have_content(@game.title)
      expect(page).to have_content(@game.platform_name)
      expect(page).to have_selector("img[src$='game_sample.png']")
    end
  end

  context '登録に失敗したとき' do
    it '' do
      
    end
  end

end