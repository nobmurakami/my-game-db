require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'Genre新規登録' do
    before do
      @genre = FactoryBot.build(:genre)
    end

    context '新規登録できるとき' do
      it 'nameがあれば登録できる' do
        expect(@genre).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'nameが既に存在すると登録できない' do
        @genre.save
        @another_genre = FactoryBot.build(:genre)
        @another_genre.name = @genre.name
        @another_genre.valid?
        expect(@another_genre.errors.full_messages).to include "Name has already been taken"
      end
    end
  end
end