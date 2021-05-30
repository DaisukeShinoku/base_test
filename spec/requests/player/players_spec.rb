require 'rails_helper'

RSpec.describe 'Player::Players', type: :request do
  describe 'プレイヤー登録画面' do
    it 'プレイヤー登録画面の表示に成功すること' do
      get player_signup_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
  describe 'プレイヤー登録の検証' do
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
        it '登録後にプロフィール画面に遷移する' do
          is_expected.to redirect_to player_player_url(Player.last)
          is_expected.to have_http_status(302)
        end
        it 'ログイン状態であることの検証' do
          expect(is_player_logged_in?).to be_truthy
        end
      end
    end
  end
  describe '認証のテスト' do
    before do
      @player = create(:player)
    end
    it '登録されたプロフィール画面を表示できないこと' do
      get player_player_path(@player)
      expect(response).to redirect_to player_login_url
      expect(response).to have_http_status(302)
    end
    it '登録されたプロフィール編集画面を表示できないこと' do
      get edit_player_player_path(@player)
      expect(response).to redirect_to player_login_url
      expect(response).to have_http_status(302)
      ### 下記でフレンドリーフォワーディングのテスト
      player_log_in_as(@player)
      expect(response).to redirect_to edit_player_player_path(@player)
    end
  end
  describe '認可のテスト' do
    before do
      @player = create(:player)
      player_log_in_as(@player)
      @other_player = create(:player)
    end
    describe 'プロフィール画面' do
      it '自身のプロフィール画面を表示できること' do
        get player_player_path(@player)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
      it '他人のプロフィール画面は表示できず自身のプロフィール画面に遷移すること' do
        get player_player_path(@other_player)
        expect(response).to redirect_to player_player_url(@player)
        expect(response).to have_http_status(302)
      end
    end
    describe 'プロフィール編集画面' do
      it '自身のプロフィール編集画面を表示できること' do
        get edit_player_player_path(@player)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
      it '他人のプロフィール編集画面は表示できず自身のプロフィール画面に遷移すること' do
        get edit_player_player_path(@other_player)
        expect(response).to redirect_to player_player_url(@player)
        expect(response).to have_http_status(302)
      end
    end
    describe 'プロフィール更新' do
      it '自身のプロフィールを更新できること' do
        patch player_player_path(@player),
              params: { player: { account_name: 'valid',
                                  display_name: '有効な表示名',
                                  prefecture_code: '北海道',
                                  email: 'valid@test.com' } }
        expect(response).to redirect_to player_player_url(@player)
        expect(response).to have_http_status(302)
      end
      it '無効な情報では更新に失敗すること' do
        patch player_player_path(@player),
              params: { player: { account_name: '',
                                  display_name: '',
                                  prefecture_code: '',
                                  email: 'invalid@test' } }
        expect(response).to render_template(:edit)
      end
      it '他人のプロフィールを更新できず自身のプロフィール画面に遷移すること' do
        patch player_player_path(@other_player),
              params: { player: { account_name: 'valid',
                                  display_name: '有効な表示名',
                                  prefecture_code: '北海道',
                                  email: 'valid@test.com' } }
        expect(response).to redirect_to player_player_url(@player)
        expect(response).to have_http_status(302)
      end
    end
  end
end
