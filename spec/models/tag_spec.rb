require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "Tag新規登録" do
    before do
      @tag = FactoryBot.build(:tag)
    end

    context "新規登録できるとき" do
      it "nameがあれば登録できる" do
        expect(@tag).to be_valid
      end
    end

    context "新規登録できないとき" do
      it "nameが既に存在すると登録できない" do
        @tag.save
        @another_tag = FactoryBot.build(:tag)
        @another_tag.name = @tag.name
        @another_tag.valid?
        expect(@another_tag.errors.full_messages).to include "タグはすでに存在します"
      end
    end
  end
end
