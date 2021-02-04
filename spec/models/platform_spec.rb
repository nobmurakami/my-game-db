require 'rails_helper'

RSpec.describe Platform, type: :model do
  describe 'Platform新規登録' do
    before do
      @platform = FactoryBot.build(:platform)
    end

    context '新規登録できるとき' do
      it 'nameがあれば登録できる' do
        expect(@platform).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'nameが既に存在すると登録できない' do
        @platform.save
        @another_platform = FactoryBot.build(:platform)
        @another_platform.name = @platform.name
        @another_platform.valid?
        expect(@another_platform.errors.full_messages).to include "機種はすでに存在します"
      end
    end
  end
end