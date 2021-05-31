require 'rails_helper'

RSpec.describe 'Team::Sessions', type: :request do
  describe 'ログイン画面' do
    it 'チームログイン画面の表示に成功すること' do
      get team_login_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe 'ログイン処理' do
    context '無効なメール/パスワードの組み合わせ' do
      it 'ログインに失敗すること' do
        post team_login_path, params: { session: { email: '', password: '' } }
        expect(response).to render_template(:new)
      end
    end
    context '有効なメール/パスワードの組み合わせ' do
      it 'ログインに成功すること' do
        email = 'login@test.com'
        password = 'login_test'
        team = create(:team, email: email, password: password, password_confirmation: password)
        post team_login_path, params: { session: { email: email, password: password } }
        expect(response).to redirect_to team_team_url(team)
        expect(is_team_logged_in?).to be_truthy
      end
    end
  end

  describe 'ログアウト' do
    context 'ログアウトできること' do
      it 'ログインしている状態でログアウトできること' do
        team = create(:team)
        post team_login_path, params: { session: { email: team.email, password: team.password } }
        delete team_login_path
        expect(response).to redirect_to root_url
        expect(is_team_logged_in?).to_not be_truthy
        ### 以下で2番目のウィンドウでログアウトをクリックするチームをシミュレート
        delete team_login_path
      end
    end
  end

  describe 'RememberMeのテスト' do
    before do
      @team = create(:team)
    end
    it 'チェックされたらクッキー情報を保持する' do
      team_log_in_as(@team)
      expect(cookies[:remember_token]).not_to eq nil
    end
    it 'チェックされていなかったらクッキー情報を保持しない' do
      team_log_in_as(@team, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end
end
