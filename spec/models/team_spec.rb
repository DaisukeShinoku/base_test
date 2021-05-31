require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'バリデーション' do
    it 'アカウント名' do
      is_expected.to validate_presence_of(:account_name)
      is_expected.to validate_length_of(:account_name).is_at_most(Team::A_NAME_MAX)
      is_expected.to validate_length_of(:account_name).is_at_least(Team::A_NAME_MIN)
    end
    it '表示名' do
      is_expected.to validate_presence_of(:display_name)
      is_expected.to validate_length_of(:display_name).is_at_most(Team::D_NAME_MAX)
    end
    it '都道府県コード' do
      is_expected.to validate_presence_of(:prefecture_code)
    end
    it 'メールアドレス' do
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_length_of(:email).is_at_most(Team::EMAIL_MAX)
    end
    it 'パスワード' do
      is_expected.to validate_presence_of(:password)
      is_expected.to validate_length_of(:password).is_at_least(Team::PASSWORD_MIN)
    end
  end

  describe 'フォーマット - アカウント名' do
    it '数字,アルファベット,アンスコが有効であること' do
      team = build(:team, account_name: 'abc_123')
      expect(team).to be_valid
    end
    it '日本語が無効であること' do
      team = build(:team, account_name: 'アイウエオ')
      expect(team).to_not be_valid
    end
    it 'アンスコ以外の特殊文字が無効であること' do
      team = build(:team, account_name: 'abc-123')
      expect(team).to_not be_valid
    end
  end

  describe 'フォーマット - メールアドレス' do
    it '一般的なメールアドレスが有効であること' do
      team = build(:team, email: 'test@test.com')
      expect(team).to be_valid
    end
    it '日本語が無効であること' do
      team = build(:team, email: 'アイウエオ@アイウエオ.com')
      expect(team).to_not be_valid
    end
    it '@がなければ無効であること' do
      team = build(:team, email: 'abc123.com')
      expect(team).to_not be_valid
    end
    it '@の後ろがドメインでなければ無効であること' do
      team = build(:team, email: 'test@test')
      expect(team).to_not be_valid
    end
  end

  describe '一意性' do
    it 'アカウント名が既に使われいたら保存できないこと' do
      team1 = create(:team, account_name: 'test')
      team2 = build(:team, account_name: 'test')
      expect(team1).to be_valid
      expect(team2).to_not be_valid
    end
    it 'メールアドレスが既に使われいたら保存できないこと' do
      team3 = create(:team, email: 'test@test.com')
      team4 = build(:team, email: 'test@test.com')
      expect(team3).to be_valid
      expect(team4).to_not be_valid
    end
    it 'メールアドレスの一意性について大文字/小文字を区別しないこと' do
      team5 = create(:team, email: 'test2@test.com')
      team6 = build(:team, email: 'TEST2@test.com')
      expect(team5).to be_valid
      expect(team6).to_not be_valid
    end
  end

  describe '複数ブラウザでのアクセスをシュミレート' do
    it 'ダイジェストが存在しない場合にfalseを返す' do
      team = build(:team)
      expect(team.authenticated?('')).to eq false
    end
  end
end
