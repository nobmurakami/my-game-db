require "rails_helper"

RSpec.describe "タグ付け機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @tagging_user1 = FactoryBot.create(:user)
    @tagging_user2 = FactoryBot.create(:user)
    @tagging_user3 = FactoryBot.create(:user)
    @game = FactoryBot.create(:game)
    @tag1 = FactoryBot.create(:tag, name: "1st TAG")
    @tag2 = FactoryBot.create(:tag, name: "2nd TAG")
    @tag3 = FactoryBot.create(:tag, name: "3rd TAG")
    @game.taggings.create(tag: @tag1, user: @tagging_user1)
    @game.taggings.create(tag: @tag1, user: @tagging_user2)
    @game.taggings.create(tag: @tag1, user: @tagging_user3)
    @game.taggings.create(tag: @tag2, user: @tagging_user1)
    @game.taggings.create(tag: @tag2, user: @tagging_user2)
    @game.taggings.create(tag: @tag3, user: @tagging_user1)
  end

  describe "タグの追加" do
    context "タグ付けできるとき" do
      it "DBに存在しないタグを作成してタグづけをすることができる" do
        # basic_pass root_path
        sign_in(@user)
        visit game_path(@game)
        expect(page).to have_button "追加"

        # DBに存在しないタグを追加し、tagsテーブルにもtaggingsテーブルにも保存されることを確認
        fill_in "tag_tag", with: "4th TAG"
        expect do
          click_on("追加")
        end.to change { Tag.count }.by(1).and change { Tagging.count }.by(1)
        expect(current_path).to eq game_path(@game)

        # 追加したタグがゲームのタグ一覧に表示されていることを確認
        expect(page).to have_content("4th TAG(1)")

        # 追加したタグの削除リンクがあることを確認
        expect(page).to have_selector("a[href$='taggings/#{Tagging.last.id}']")
      end

      it "DBに存在するタグを使用してタグづけをすることができる" do
        # basic_pass root_path
        sign_in(@user)
        visit game_path(@game)
        expect(page).to have_button "追加"

        # DBに存在するタグを追加し、tagsテーブルには保存されないがtaggingsテーブルには保存されることを確認
        fill_in "tag_tag", with: @tag1.name
        expect do
          click_on("追加")
        end.to change { Tag.count }.by(0).and change { Tagging.count }.by(1)
        expect(current_path).to eq game_path(@game)

        # 追加したタグがゲームのタグ一覧に表示されていることを確認
        expect(page).to have_content("#{@tag1.name}(#{@tag1.taggings.where(game_id: @game).count})")

        # 追加したタグの削除リンクがあることを確認
        expect(page).to have_selector("a[href$='taggings/#{Tagging.last.id}']")
      end
    end

    context "タグ付けできないとき" do
      it "ログインしていないとタグ付けできない" do
        # basic_pass root_path
        visit game_path(@game)
        expect(page).not_to have_button "追加"
      end

      it "フォームが空だとタグ付けできない" do
        # basic_pass root_path
        sign_in(@user)
        visit game_path(@game)
        expect(page).to have_button "追加"

        # 何も入力せずに作成ボタンをクリックすると、tagsテーブルとtaggingsテーブルのどちらにもデータが保存されない
        expect do
          click_on("追加")
        end.to change { Tag.count }.by(0).and change { Tagging.count }.by(0)

        expect(current_path).to eq game_path(@game)
      end
    end
  end

  describe "タグの削除" do
    before do
      @tag = FactoryBot.create(:tag, name: "MY TAG")
      @game.taggings.create(tag: @tag, user: @user)
    end

    context "タグの削除ができるとき" do
      it "ログインしていればゲーム詳細ページで自分のタグを削除できる" do
        # basic_pass root_path
        sign_in(@user)
        visit game_path(@game)

        expect(page).to have_content(@tag.name)
        expect(page).to have_selector("a[href$='taggings/#{@user.taggings[0].id}']")

        expect do
          click_on(@tag.name)
        end.to change { Tag.count }.by(0).and change { Tagging.count }.by(-1)

        expect(current_path).to eq game_path(@game)

        expect(page).not_to have_content(@tag.name)
        expect(page).not_to have_selector("a[href$='taggings/#{@user.taggings[0].id}']")
      end
    end

    context "タグの削除ができないとき" do
      it "ログインしていないと自分のタグを削除できない" do
        # basic_pass root_path
        visit game_path(@game)

        expect(page).to have_content(@tag.name)
        expect(page).not_to have_selector("a[href$='taggings/#{@user.taggings[0].id}']")
      end
    end
  end

  describe "タグの表示" do
    it "ゲームのタグはタグづけされた数の多い順に並んでいる" do
      # basic_pass root_path
      visit game_path(@game)

      tags = all("a[href^='/tags/']")
      expect(tags[0].text).to eq "#{@tag1.name}(#{@tag1.taggings.where(game_id: @game).count})"
      expect(tags[1].text).to eq "#{@tag2.name}(#{@tag2.taggings.where(game_id: @game).count})"
      expect(tags[2].text).to eq "#{@tag3.name}(#{@tag3.taggings.where(game_id: @game).count})"
    end

    it "タグづけされた数が変わると表示の順番が入れ替わる" do
      @game.taggings.create(tag: @tag2, user: @tagging_user3)

      # basic_pass root_path
      sign_in(@user)
      visit game_path(@game)

      tags = all("a[href^='/tags/']")
      expect(tags[0].text).to eq "#{@tag1.name}(#{@tag1.taggings.where(game_id: @game).count})"
      expect(tags[1].text).to eq "#{@tag2.name}(#{@tag2.taggings.where(game_id: @game).count})"

      fill_in "tag_tag", with: @tag2.name
      expect do
        click_on("追加")
      end.to change { Tag.count }.by(0).and change { Tagging.count }.by(1)
      expect(current_path).to eq game_path(@game)

      tags = all("a[href^='/tags/']")
      expect(tags[0].text).to eq "#{@tag2.name}(#{@tag2.taggings.where(game_id: @game).count})"
      expect(tags[1].text).to eq "#{@tag1.name}(#{@tag1.taggings.where(game_id: @game).count})"
    end
  end
end
