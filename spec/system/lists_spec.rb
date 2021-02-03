require 'rails_helper'

RSpec.describe "Lists", type: :system do
  describe '詳細画面でゲームをリストに追加する' do

    before do
      @user = FactoryBot.create(:user)
      @game = FactoryBot.create(:game)
    end

    context 'ユーザーがログインしている場合' do
      context 'ユーザーがゲームをリストに追加していない場合' do
        it 'WANTボタンを押すとユーザーのWANTリストにゲームが追加される' do
          sign_in(@user)
          visit game_path(@game)
          
          # WANTボタンを押すとlistsテーブルのレコードが増えることを確認
          expect {
            click_on('WANT')
          }.to change { List.count }.by(1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/lists'][data-method='delete']")

          # ユーザーのWant to Playリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Want to Play')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYINGボタンを押すとユーザーのPLAYINGリストにゲームが追加される' do
          sign_in(@user)
          visit game_path(@game)
          
          # PLAYINGボタンを押すとlistsテーブルのレコードが増えることを確認
          expect {
            click_on('PLAYING')
          }.to change { List.count }.by(1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/lists'][data-method='delete']")

          # ユーザーのPlayingリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Playing')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYEDボタンを押すとユーザーのPLAYEDリストにゲームが追加される' do
          sign_in(@user)
          visit game_path(@game)
          
          # PLAYEDボタンを押すとlistsテーブルのレコードが増えることを確認
          expect {
            click_on('PLAYED')
          }.to change { List.count }.by(1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/lists'][data-method='delete']")

          # ユーザーのPlayedリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Played')
          expect(page).to have_content(@game.title)
        end
      end

      context 'ユーザーがゲームをWANTリストに追加している場合' do
        before do
          @user.want_games << @game
        end

        it 'WANTボタンを押すとゲームがユーザーのWANTリストから削除される' do
          sign_in(@user)
          visit game_path(@game)

          # WANTボタンを押すとlistsテーブルのレコードが減ることを確認
          expect {
            click_on('WANT')
          }.to change { List.count }.by(-1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのWant to Playリスト一覧表示にゲームが表示されていないことを確認
          visit user_path(@user)
          click_on('Want to Play')
          expect(page).not_to have_content(@game.title)
        end

        it 'PLAYINGボタンを押すとゲームがユーザーのWANTリストからPLAYINGリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYINGボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('PLAYING')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayingリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Playing')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYEDボタンを押すとゲームがユーザーのWANTリストからPLAYEDリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYEDボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('PLAYED')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayedリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Played')
          expect(page).to have_content(@game.title)
        end
      end

      context 'ユーザーがゲームをPLAYINGリストに追加している場合' do
        before do
          @user.playing_games << @game
        end

        it 'WANTボタンを押すとゲームがユーザーのPLAYINGリストからWANTリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # WANTボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('WANT')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのWant to Playリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Want to Play')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYINGボタンを押すとゲームがユーザーのPLAYINGリストから削除される' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYINGボタンを押すとlistsテーブルのレコードが減ることを確認
          expect {
            click_on('PLAYING')
          }.to change { List.count }.by(-1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayingリスト一覧表示にゲームが表示されていないことを確認
          visit user_path(@user)
          click_on('Playing')
          expect(page).not_to have_content(@game.title)
        end

        it 'PLAYEDボタンを押すとゲームがユーザーのPLAYINGリストからPLAYEDリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYEDボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('PLAYED')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayedリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Played')
          expect(page).to have_content(@game.title)
        end
      end

      context 'ユーザーがゲームをPLAYEDリストに追加している場合' do
        before do
          @user.played_games << @game
        end

        it 'WANTボタンを押すとゲームがユーザーのPLAYEDリストからWANTリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # WANTボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('WANT')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのWant to Playリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Want to Play')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYINGボタンを押すとゲームがユーザーのPLAYEDリストからPLAYINGリストに移動する' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYINGボタンを押した時にlistsテーブルのレコード数が変わらないことを確認
          expect {
            click_on('PLAYING')
          }.to change { List.count }.by(0)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayingリスト一覧表示にゲームが表示されていることを確認
          visit user_path(@user)
          click_on('Playing')
          expect(page).to have_content(@game.title)
        end

        it 'PLAYEDボタンを押すとゲームがユーザーのPLAYEDリストから削除される' do
          sign_in(@user)
          visit game_path(@game)

          # PLAYEDボタンを押すとlistsテーブルのレコードが減ることを確認
          expect {
            click_on('PLAYED')
          }.to change { List.count }.by(-1)
          expect(current_path).to eq game_path(@game)

          # ユーザーのPlayedリスト一覧表示にゲームが表示されていないことを確認
          visit user_path(@user)
          click_on('Played')
          expect(page).not_to have_content(@game.title)
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'WANTボタンを押すとログイン画面に遷移する'do
        visit game_path(@game)

        click_on('WANT')
        expect(current_path).to eq new_user_session_path
      end

      it 'PLAYINGボタンを押すとログイン画面に遷移する'do
        visit game_path(@game)

        click_on('PLAYING')
        expect(current_path).to eq new_user_session_path
      end

      it 'PLAYEDボタンを押すとログイン画面に遷移する'do
        visit game_path(@game)

        click_on('PLAYED')
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
