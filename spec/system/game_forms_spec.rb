require "rails_helper"

RSpec.describe "ゲーム情報の投稿", type: :system do
  describe "新規登録" do
    before do
      @user = FactoryBot.create(:user)
      @game = FactoryBot.build(:game_form)
    end

    context "登録に成功したとき" do
      it "ゲームの登録に成功すると、ゲーム一覧に遷移して、登録したゲームが表示されている" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # 最低限の項目だけ入力してゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)
        expect(current_path).to eq root_path

        # 登録したゲームが表示されている
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform_name)
      end

      it "Steam以外の全ての項目を入力してゲームを登録すると、ゲーム一覧と詳細ページに入力した内容が表示されている" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # 全ての項目を入力してゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        image_path = Rails.root.join("public/images/game_sample.png")
        attach_file("game_form_image", image_path)
        fill_in "game_form_description", with: @game.description
        fill_in "game_form_metascore", with: @game.metascore
        fill_in "game_form_release_date", with: @game.release_date.to_s(:stamp)
        fill_in "game_form_genre_names", with: @game.genre_names
        fill_in "game_form_developer_names", with: @game.developer_names
        fill_in "game_form_publisher_names", with: @game.publisher_names

        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)
        expect(current_path).to eq root_path

        # ゲーム一覧に入力した内容が表示されている
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform_name)
        expect(page).to have_selector("img[src$='game_sample.png']")
        expect(page).to have_content("メタスコア：#{@game.metascore}")
        expect(page).to have_content(@game.release_date.to_s(:stamp))

        # ゲーム詳細ページに入力した内容が表示されている
        click_on(@game.title)
        expect(current_path).to eq game_path(Game.first)
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform_name)
        expect(page).to have_selector("img[src$='game_sample.png']")
        expect(page).to have_content(@game.metascore)
        expect(page).to have_content(@game.release_date.to_s(:stamp))
        expect(page).to have_content(@game.description)
        expect(page).to have_content(@game.genre_names.split(", ")[0])
        expect(page).to have_content(@game.genre_names.split(", ")[1])
        expect(page).to have_content(@game.developer_names.split(", ")[0])
        expect(page).to have_content(@game.developer_names.split(", ")[1])
        expect(page).to have_content(@game.publisher_names.split(", ")[0])
        expect(page).to have_content(@game.publisher_names.split(", ")[1])
      end

      it "ジャンルにスペースだけ入力しても空文字のレコードが作られない" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # ジャンルにスペースだけ入力してゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        fill_in "game_form_genre_names", with: " 　" # 半角スペースと全角スペース
        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)

        # genresテーブルのカウントが増えないことを確認
        expect(Genre.count).to eq 0
      end

      it "ジャンルを複数入力する場合にスペースだけの入力があっても空文字のレコードが作られない" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # ジャンルに、カンマで空文字をはさんだ文字列を含めてゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        fill_in "game_form_genre_names", with: ", ,　,a, 　 , b,,,"
        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)

        # genresテーブルのカウントが、空以外の要素分しか増えないことを確認
        expect(Genre.count).to eq 2
      end

      it "開発元と発売元にスペースだけ入力しても空文字のレコードが作られない" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # 開発元と発売元にスペースだけ入力してゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        fill_in "game_form_developer_names", with: " 　" # 半角スペースと全角スペース
        fill_in "game_form_publisher_names", with: " 　" # 半角スペースと全角スペース
        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)

        # companiesテーブルのカウントが増えないことを確認
        expect(Company.count).to eq 0
      end

      it "開発元と発売元を複数入力する場合にスペースだけの入力があっても空文字のレコードが作られない" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # 開発元と発売元に、カンマで空文字をはさんだ文字列を含めてゲームを登録する
        fill_in "game_form_title", with: @game.title
        fill_in "game_form_platform_name", with: @game.platform_name
        fill_in "game_form_developer_names", with: ", ,　,a, 　 , b,,,"
        fill_in "game_form_publisher_names", with: ", ,　,c, 　 , d,,,"
        expect do
          click_on("登録")
        end.to change { Game.count }.by(1)

        # companiesテーブルのカウントが空以外の要素分しか増えないことを確認
        expect(Company.count).to eq 4
      end
    end

    context "登録に失敗したとき" do
      it "タイトルを入力しないと登録に失敗する" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # タイトル以外の項目を入力する
        fill_in "game_form_platform_name", with: @game.platform_name
        image_path = Rails.root.join("public/images/game_sample.png")
        attach_file("game_form_image", image_path)
        fill_in "game_form_description", with: @game.description
        fill_in "game_form_metascore", with: @game.metascore
        fill_in "game_form_release_date", with: @game.release_date.to_s(:stamp)
        fill_in "game_form_genre_names", with: @game.genre_names
        fill_in "game_form_developer_names", with: @game.developer_names
        fill_in "game_form_publisher_names", with: @game.publisher_names

        # 登録ボタンを押してもDBに保存されない
        expect do
          click_on("登録")
        end.not_to change { Game.count }

        # 元のページに戻ってくる
        expect(current_path).to eq "/games"

        # エラーメッセージが表示されていることを確認
        expect(page).to have_content("タイトルを入力してください")
      end

      it "機種を入力しないと登録に失敗する" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム新規登録画面に遷移する
        visit new_game_path
        expect(current_path).to eq new_game_path

        # 機種以外の項目を入力する
        fill_in "game_form_title", with: @game.title
        image_path = Rails.root.join("public/images/game_sample.png")
        attach_file("game_form_image", image_path)
        fill_in "game_form_description", with: @game.description
        fill_in "game_form_metascore", with: @game.metascore
        fill_in "game_form_release_date", with: @game.release_date.to_s(:stamp)
        fill_in "game_form_genre_names", with: @game.genre_names
        fill_in "game_form_developer_names", with: @game.developer_names
        fill_in "game_form_publisher_names", with: @game.publisher_names

        # 登録ボタンを押してもDBに保存されないことを確認
        expect do
          click_on("登録")
        end.not_to change { Game.count }

        # 元のページに戻ってくることを確認
        expect(current_path).to eq "/games"

        # エラーメッセージが表示されていることを確認
        expect(page).to have_content("機種を入力してください")
      end
    end
  end

  describe "ゲーム情報の更新" do
    before do
      @user = FactoryBot.create(:user)
      @tagging_user1 = FactoryBot.create(:user)
      @tagging_user2 = FactoryBot.create(:user)
      @game = FactoryBot.create(:game, :full_info)
      @tag1 = FactoryBot.create(:tag, name: "1st TAG")
      @tag2 = FactoryBot.create(:tag, name: "2nd TAG")
      @game.taggings.create(tag: @tag1, user: @tagging_user1)
      @game.taggings.create(tag: @tag2, user: @tagging_user2)
      @edit = FactoryBot.build(:game_form)
    end

    context "更新に成功したとき" do
      it "ゲームの更新に成功すると、ゲーム詳細ページに遷移して、更新した内容が表示されている" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム詳細ページに遷移する
        click_on(@game.title)
        expect(current_path).to eq game_path(@game)

        # ゲーム編集ページに遷移する
        click_on("編集")
        expect(current_path).to eq edit_game_path(@game)

        # 全ての項目を書き換える
        fill_in "game_form_title", with: ""
        fill_in "game_form_title", with: @edit.title
        fill_in "game_form_platform_name", with: ""
        fill_in "game_form_platform_name", with: @edit.platform_name
        image_path = Rails.root.join("public/images/game_sample2.png")
        attach_file("game_form_image", image_path)
        fill_in "game_form_description", with: ""
        fill_in "game_form_description", with: @edit.description
        fill_in "game_form_metascore", with: ""
        fill_in "game_form_metascore", with: @edit.metascore
        fill_in "game_form_release_date", with: ""
        fill_in "game_form_release_date", with: @edit.release_date
        fill_in "game_form_genre_names", with: ""
        fill_in "game_form_genre_names", with: @edit.genre_names
        fill_in "game_form_developer_names", with: ""
        fill_in "game_form_developer_names", with: @edit.developer_names
        fill_in "game_form_publisher_names", with: ""
        fill_in "game_form_publisher_names", with: @edit.publisher_names

        # フォームを送信するとゲーム詳細ページに遷移する
        click_on("更新")
        expect(current_path).to eq game_path(@game)

        # ゲーム詳細ページに更新した内容が表示されている
        expect(page).to have_content(@edit.title)
        expect(page).to have_content(@edit.platform_name)
        expect(page).to have_selector("img[src$='game_sample2.png']")
        expect(page).to have_content(@edit.metascore)
        expect(page).to have_content(@edit.release_date.to_s(:stamp))
        expect(page).to have_content(@edit.description)
        expect(page).to have_content(@edit.genre_names.split(", ")[0])
        expect(page).to have_content(@edit.genre_names.split(", ")[1])
        expect(page).to have_content(@edit.developer_names.split(", ")[0])
        expect(page).to have_content(@edit.developer_names.split(", ")[1])
        expect(page).to have_content(@edit.publisher_names.split(", ")[0])
        expect(page).to have_content(@edit.publisher_names.split(", ")[1])
      end

      it "何も編集せずに更新しても元のデータが消えない" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム詳細ページに遷移する
        click_on(@game.title)
        expect(current_path).to eq game_path(@game)

        # ゲーム編集ページに遷移する
        click_on("編集")
        expect(current_path).to eq edit_game_path(@game)

        # 編集せずにフォームを送信する
        click_on("更新")
        expect(current_path).to eq game_path(@game)

        # ゲーム詳細ページに元の内容が表示されている
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform.name)
        expect(page).to have_selector("img[src$='game_sample.png']")
        expect(page).to have_content(@game.metascore)
        expect(page).to have_content(@game.release_date.to_s(:stamp))
        expect(page).to have_content(@game.description)
        expect(page).to have_content(@game.genres[0].name)
        expect(page).to have_content(@game.genres[1].name)
        expect(page).to have_content(@game.developers[0].name)
        expect(page).to have_content(@game.developers[1].name)
        expect(page).to have_content(@game.publishers[0].name)
        expect(page).to have_content(@game.publishers[1].name)
      end
    end

    context "更新に失敗したとき" do
      it "タイトルを入力しないと更新に失敗する" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム詳細ページに遷移する
        click_on(@game.title)
        expect(current_path).to eq game_path(@game)

        # ゲーム編集ページに遷移する
        click_on("編集")
        expect(current_path).to eq edit_game_path(@game)

        # 入力されているタイトルを消してフォーム送信
        fill_in "game_form_title", with: ""
        click_on("更新")

        # 元のページに戻されてエラーメッセージが表示される
        expect(current_path).to eq "/games/#{@game.id}"
        expect(page).to have_content("タイトルを入力してください")
      end

      it "機種を入力しないと更新に失敗する" do
        basic_pass root_path
        # サインインする
        sign_in(@user)

        # ゲーム詳細ページに遷移する
        click_on(@game.title)
        expect(current_path).to eq game_path(@game)

        # ゲーム編集ページに遷移する
        click_on("編集")
        expect(current_path).to eq edit_game_path(@game)

        # 入力されている機種を消してフォーム送信
        fill_in "game_form_platform_name", with: ""
        click_on("更新")

        # 元のページに戻されてエラーメッセージが表示される
        expect(current_path).to eq "/games/#{@game.id}"
        expect(page).to have_content("機種を入力してください")
      end
    end
  end

  describe "ゲーム情報の表示" do
    context "最低限の情報のみ登録されている場合" do
      before do
        @game = FactoryBot.create(:game)
      end

      it "一覧表示でタイトルと機種が表示されている" do
        basic_pass root_path
        visit root_path

        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform.name)
        expect(page).to have_selector("img[src^='/assets/noimage']")
      end

      it "詳細表示でタイトルと機種だけが表示されている" do
        visit game_path(@game)

        # タイトル、機種、[NO IMAGE]画像、TBDが表示されていることを確認
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform.name)
        expect(page).to have_selector("img[src^='/assets/noimage']")
        expect(page).to have_content("TBD")

        # その他の情報は見出しごと非表示になっていることを確認
        expect(page).not_to have_content("METASCORE")
        expect(page).not_to have_content("DEVELOPERS")
        expect(page).not_to have_content("PUBLISHERS")
        expect(page).not_to have_content("GENRE")
        expect(page).not_to have_content("TAGS")
      end
    end

    context "全ての情報が登録されている場合" do
      before do
        @game = FactoryBot.create(:game, :full_info)
      end

      it "一覧表示で添付画像、タイトル、機種、メタスコア 、発売日が表示されている" do
        basic_pass root_path
        visit root_path
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform.name)
        expect(page).to have_selector("img[src$='game_sample.png']")
        expect(page).to have_content("メタスコア：#{@game.metascore}")
        expect(page).to have_content(@game.release_date.to_s(:stamp))
      end

      it "詳細表示で全ての情報が表示されている" do
        basic_pass root_path
        visit game_path(@game)

        # 登録されている情報が表示されていることを確認
        expect(page).to have_content(@game.title)
        expect(page).to have_content(@game.platform.name)
        expect(page).to have_selector("img[src$='game_sample.png']")
        expect(page).to have_content(@game.metascore)
        expect(page).to have_content(@game.release_date.to_s(:stamp))
        expect(page).to have_content(@game.description)
        expect(page).to have_content(@game.genres[0].name)
        expect(page).to have_content(@game.genres[1].name)
        expect(page).to have_content(@game.developers[0].name)
        expect(page).to have_content(@game.developers[1].name)
        expect(page).to have_content(@game.publishers[0].name)
        expect(page).to have_content(@game.publishers[1].name)
      end
    end

    context "imageが無くsteam_imageが存在する場合" do
      before do
        @game = FactoryBot.create(:game, :full_info)
        @game.image.purge
      end

      it "一覧表示と詳細表示にSteamのゲーム画像が表示されている" do
        basic_pass root_path
        visit root_path
        expect(page).to have_selector("img[src='#{@game.steam_image}']")

        visit game_path(@game)
        expect(page).to have_selector("img[src='#{@game.steam_image}']")
      end
    end
  end
end
