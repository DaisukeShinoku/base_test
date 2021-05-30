require 'rails_helper'

RSpec.describe 'Player::Sessions', type: :request do
  describe 'ログイン画面' do
    it 'プレイヤーログイン画面の表示に成功すること' do
      get player_login_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe 'ログイン処理' do
    context '無効なメール/パスワードの組み合わせ' do
      it 'ログインに失敗すること' do
        post player_login_path, params: { session: { email: '', password: '' } }
        expect(response).to render_template(:new)
      end
    end
    context '有効なメール/パスワードの組み合わせ' do
      it 'ログインに成功すること' do
        email = 'login@test.com'
        password = 'login_test'
        player = create(:player, email: email, password: password, password_confirmation: password)
        post player_login_path, params: { session: { email: email, password: password } }
        expect(response).to redirect_to player_player_url(player)
        expect(is_player_logged_in?).to be_truthy
      end
    end
  end

  describe 'ログアウト' do
    context 'ログアウトできること' do
      it 'ログインしている状態でログアウトできること' do
        player = create(:player)
        post player_login_path, params: { session: { email: player.email, password: player.password } }
        delete player_login_path
        expect(response).to redirect_to root_url
        expect(is_player_logged_in?).to_not be_truthy
        ### 以下で2番目のウィンドウでログアウトをクリックする選手をシミュレート
        delete player_login_path
      end
    end
  end

  describe 'RememberMeのテスト' do
    before do
      @player = create(:player)
    end
    it 'チェックされたらクッキー情報を保持する' do
      player_log_in_as(@player)
      expect(cookies[:remember_token]).not_to eq nil
    end
    it 'チェックされていなかったらクッキー情報を保持しない' do
      player_log_in_as(@player, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end
end
