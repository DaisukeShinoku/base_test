require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'バリデーション' do
    it 'アカウント名' do
      is_expected.to validate_presence_of(:account_name)
      is_expected.to validate_length_of(:account_name).is_at_most(Player::A_NAME_MAX)
      is_expected.to validate_length_of(:account_name).is_at_least(Player::A_NAME_MIN)
    end
    it '表示名' do
      is_expected.to validate_presence_of(:display_name)
      is_expected.to validate_length_of(:display_name).is_at_most(Player::D_NAME_MAX)
    end
    it '都道府県コード' do
      is_expected.to validate_presence_of(:prefecture_code)
    end
    it 'メールアドレス' do
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_length_of(:email).is_at_most(Player::EMAIL_MAX)
    end
    it 'パスワード' do
      is_expected.to validate_presence_of(:password)
      is_expected.to validate_length_of(:password).is_at_least(Player::PASSWORD_MIN)
    end
  end

  describe 'フォーマット - アカウント名' do
    it '数字,アルファベット,アンスコが有効であること' do
      player = build(:player, account_name: 'abc_123')
      expect(player).to be_valid
    end
    it '日本語が無効であること' do
      player = build(:player, account_name: 'アイウエオ')
      expect(player).to_not be_valid
    end
    it 'アンスコ以外の特殊文字が無効であること' do
      player = build(:player, account_name: 'abc-123')
      expect(player).to_not be_valid
    end
  end

  describe 'フォーマット - メールアドレス' do
    it '一般的なメールアドレスが有効であること' do
      player = build(:player, email: 'test@test.com')
      expect(player).to be_valid
    end
    it '日本語が無効であること' do
      player = build(:player, email: 'アイウエオ@アイウエオ.com')
      expect(player).to_not be_valid
    end
    it '@がなければ無効であること' do
      player = build(:player, email: 'abc123.com')
      expect(player).to_not be_valid
    end
    it '@の後ろがドメインでなければ無効であること' do
      player = build(:player, email: 'test@test')
      expect(player).to_not be_valid
    end
  end

  describe '一意性' do
    it 'アカウント名が既に使われいたら保存できないこと' do
      player1 = create(:player, account_name: 'test')
      player2 = build(:player, account_name: 'test')
      expect(player1).to be_valid
      expect(player2).to_not be_valid
    end
    it 'メールアドレスが既に使われいたら保存できないこと' do
      player3 = create(:player, email: 'test@test.com')
      player4 = build(:player, email: 'test@test.com')
      expect(player3).to be_valid
      expect(player4).to_not be_valid
    end
    it 'メールアドレスの一意性について大文字/小文字を区別しないこと' do
      player5 = create(:player, email: 'test2@test.com')
      player6 = build(:player, email: 'TEST2@test.com')
      expect(player5).to be_valid
      expect(player6).to_not be_valid
    end
  end

  describe '複数ブラウザでのアクセスをシュミレート' do
    it 'ダイジェストが存在しない場合にfalseを返す' do
      player = build(:player)
      expect(player.authenticated?('')).to eq false
    end
  end
end
