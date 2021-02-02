require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'Company新規登録' do
    before do
      @company = FactoryBot.build(:company)
    end

    context '新規登録できるとき' do
      it 'nameがあれば登録できる' do
        expect(@company).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'nameが既に存在すると登録できない' do
        @company.save
        @another_company = FactoryBot.build(:company)
        @another_company.name = @company.name
        @another_company.valid?
        expect(@another_company.errors.full_messages).to include "Name has already been taken"
      end
    end
  end
end