require "rails_helper"

RSpec.describe "PlayLists", type: :system do
  describe "詳細画面でゲームをリストに追加する" do
    before do
      @user = FactoryBot.create(:user)
      @game = FactoryBot.create(:game)
    end

    context "ユーザーがログインしている場合" do
      context "ユーザーがゲームをリストに追加していない場合" do
        it "プレイ予定ボタンを押すとユーザーのプレイ予定リストにゲームが追加される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ予定ボタンを押すとplay_listsテーブルのレコードが増えることを確認
          check_create_list(@game, "プレイ予定")

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/play_lists'][data-method='delete']")
        
          # ユーザーのプレイ予定リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ予定")
        end

        it "プレイ中ボタンを押すとユーザーのプレイ中リストにゲームが追加される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ中ボタンを押すとplay_listsテーブルのレコードが増えることを確認
          check_create_list(@game, "プレイ中")

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/play_lists'][data-method='delete']")

          # ユーザーのプレイ中リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ中")
        end

        it "プレイ済みボタンを押すとユーザーのプレイ済みリストにゲームが追加される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ済みボタンを押すとplay_listsテーブルのレコードが増えることを確認
          check_create_list(@game, "プレイ済み")

          # ユーザーのリストの削除リンクがあることを確認
          expect(page).to have_selector("a[href='/games/#{@game.id}/play_lists'][data-method='delete']")

          # ユーザーのプレイ済みリスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ済み")
        end
      end

      context "ユーザーがゲームをプレイ予定リストに追加している場合" do
        before do
          @user.want_games << @game
        end

        it "プレイ予定ボタンを押すとゲームがユーザーのプレイ予定リストから削除される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ予定ボタンを押すとplay_listsテーブルのレコードが減ることを確認
          check_delete_list(@game, "プレイ予定")

          # ユーザーのプレイ予定リスト一覧表示にゲームが表示されていないことを確認
          check_game_not_in_user_list(@game, @user, "プレイ予定")
        end

        it "プレイ中ボタンを押すとゲームがユーザーのプレイ予定リストからプレイ中リストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ中ボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ中")

          # ユーザーのプレイ中リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ中")
        end

        it "プレイ済みボタンを押すとゲームがユーザーのプレイ予定リストからプレイ済みリストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ済みボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ済み")

          # ユーザーのプレイ済みリスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ済み")
        end
      end

      context "ユーザーがゲームをプレイ中リストに追加している場合" do
        before do
          @user.playing_games << @game
        end

        it "プレイ予定ボタンを押すとゲームがユーザーのプレイ中リストからプレイ予定リストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ予定ボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ予定")

          # ユーザーのプレイ予定リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ予定")
        end

        it "プレイ中ボタンを押すとゲームがユーザーのプレイ中リストから削除される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ中ボタンを押すとplay_listsテーブルのレコードが減ることを確認
          check_delete_list(@game, "プレイ中")

          # ユーザーのプレイ中リスト一覧表示にゲームが表示されていないことを確認
          check_game_not_in_user_list(@game, @user, "プレイ中")
        end

        it "プレイ済みボタンを押すとゲームがユーザーのプレイ中リストからプレイ済みリストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ済みボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ済み")

          # ユーザーのプレイ済みリスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ済み")
        end
      end

      context "ユーザーがゲームをプレイ済みリストに追加している場合" do
        before do
          @user.played_games << @game
        end

        it "プレイ予定ボタンを押すとゲームがユーザーのプレイ済みリストからプレイ予定リストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ予定ボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ予定")

          # ユーザーのプレイ予定リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ予定")
        end

        it "プレイ中ボタンを押すとゲームがユーザーのプレイ済みリストからプレイ中リストに移動する" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ中ボタンを押した時にplay_listsテーブルのレコード数が変わらないことを確認
          check_move_list(@game, "プレイ中")

          # ユーザーのプレイ中リスト一覧表示にゲームが表示されていることを確認
          check_game_in_user_list(@game, @user, "プレイ中")
        end

        it "プレイ済みボタンを押すとゲームがユーザーのプレイ済みリストから削除される" do
          basic_pass root_path
          sign_in(@user)
          visit game_path(@game)

          # プレイ済みボタンを押すとplay_listsテーブルのレコードが減ることを確認
          check_delete_list(@game, "プレイ済み")

          # ユーザーのプレイ済みリスト一覧表示にゲームが表示されていないことを確認
          check_game_not_in_user_list(@game, @user, "プレイ済み")
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      it "プレイ予定ボタンを押すとログイン画面に遷移する" do
        basic_pass root_path
        visit game_path(@game)

        click_on("プレイ予定")
        expect(current_path).to eq new_user_session_path
      end

      it "プレイ中ボタンを押すとログイン画面に遷移する" do
        basic_pass root_path
        visit game_path(@game)

        click_on("プレイ中")
        expect(current_path).to eq new_user_session_path
      end

      it "プレイ済みボタンを押すとログイン画面に遷移する" do
        basic_pass root_path
        visit game_path(@game)

        click_on("プレイ済み")
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
