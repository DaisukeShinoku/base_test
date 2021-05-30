require 'rails_helper'

RSpec.describe 'Player::Players', type: :request do
  describe 'GET player/signup' do
    it 'ログイン画面の表示に成功すること' do
      get player_signup_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
  describe 'POST player/players' do
    context '無効なプレイヤーデータ' do
      let(:player_params) do
        attributes_for(:player,
                       account_name: '',
                       display_name: '',
                       prefecture_code: '北海道',
                       email: 'invalid@email',
                       password: '',
                       password_confirmation: '')
      end
      it '登録が失敗すること' do
        expect do
          post player_signup_path, params: { player: player_params }
        end.to change(Player, :count).by(0)
      end
    end
    context '有効なプレイヤーデータ' do
      let(:player_params) do
        attributes_for(:player)
      end
      it '登録が成功すること' do
        expect do
          post player_signup_path, params: { player: player_params }
        end.to change(Player, :count).by(1)
      end
      context 'プレイヤーが追加されたことの検証' do
        before { post player_signup_path, params: { player: attributes_for(:player) } }
        subject { response }
        it { is_expected.to redirect_to player_player_path(Player.last) }
        it { is_expected.to have_http_status(302) }
      end
    end
  end
end
