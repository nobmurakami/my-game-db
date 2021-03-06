require "rails_helper"

RSpec.describe GameForm, type: :model do
  describe "ゲームの登録" do
    before do
      @form = FactoryBot.build(:game_form)
      @form.image = fixture_file_upload("public/images/game_sample.png")
    end

    context "ゲームの登録ができるとき" do
      it "必要な情報を適切に入力するとゲームの登録ができる" do
        expect(@form).to be_valid
      end

      it "imageは空でも登録できる" do
        @form.image = nil
        expect(@form).to be_valid
      end

      it "descriptionは空でも登録できる" do
        @form.description = nil
        expect(@form).to be_valid
      end

      it "metascoreは空でも登録できる" do
        @form.metascore = nil
        expect(@form).to be_valid
      end

      it "release_dateは空でも登録できる" do
        @form.release_date = nil
        expect(@form).to be_valid
      end

      it "genre_namesは空でも登録できる" do
        @form.genre_names = nil
        expect(@form).to be_valid
      end

      it "developer_namesは空でも登録できる" do
        @form.developer_names = nil
        expect(@form).to be_valid
      end

      it "publisher_namesは空でも登録できる" do
        @form.publisher_names = nil
        expect(@form).to be_valid
      end

      it "steamは空でも登録できる" do
        @form.steam = nil
        expect(@form).to be_valid
      end
    end

    context "ゲームの登録ができないとき" do
      it "titleが空だと登録できない" do
        @form.title = nil
        @form.valid?
        expect(@form.errors.full_messages).to include "タイトルを入力してください"
      end

      it "platform_nameが空だと登録できない" do
        @form.platform_name = nil
        @form.valid?
        expect(@form.errors.full_messages).to include "機種を入力してください"
      end

      it "metascoreが100を超過すると登録できない" do
        @form.metascore = 101
        @form.valid?
        expect(@form.errors.full_messages).to include "メタスコアは100以下の値にしてください"
      end

      it "metascoreが0未満だと登録できない" do
        @form.metascore = -1
        @form.valid?
        expect(@form.errors.full_messages).to include "メタスコアは0以上の値にしてください"
      end

      it "metascoreが数字以外だと登録できない" do
        @form.metascore = "a"
        @form.valid?
        expect(@form.errors.full_messages).to include "メタスコアは数値で入力してください"
      end

      it "steamにappidが含まれていないと登録できない" do
        @form.steam = "https://store.steampowered.com/app/"
        @form.valid?
        expect(@form.errors.full_messages).to include "STEAMは不正な値です"
      end
    end
  end
end
