require 'rails_helper'

RSpec.describe 'Team::Teams', type: :request do
  describe 'チーム登録画面' do
    it 'チーム登録画面の表示に成功すること' do
      get team_signup_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
  describe 'チーム登録の検証' do
    context '無効なチームデータ' do
      let(:team_params) do
        attributes_for(:team,
                       account_name: '',
                       display_name: '',
                       prefecture_code: '北海道',
                       email: 'invalid@email',
                       password: '',
                       password_confirmation: '')
      end
      it '登録が失敗すること' do
        expect do
          post team_signup_path, params: { team: team_params }
        end.to change(Team, :count).by(0)
      end
    end
    context '有効なチームデータ' do
      let(:team_params) do
        attributes_for(:team)
      end
      it '登録が成功すること' do
        expect do
          post team_signup_path, params: { team: team_params }
        end.to change(Team, :count).by(1)
      end
      context 'チームが追加されたことの検証' do
        before { post team_signup_path, params: { team: attributes_for(:team) } }
        subject { response }
        it '登録後にプロフィール画面に遷移する' do
          is_expected.to redirect_to team_team_url(Team.last)
          is_expected.to have_http_status(302)
        end
        it 'ログイン状態であることの検証' do
          expect(is_team_logged_in?).to be_truthy
        end
      end
    end
  end
  describe '認証のテスト' do
    before do
      @team = create(:team)
    end
    it '登録されたプロフィール画面を表示できないこと' do
      get team_team_path(@team)
      expect(response).to redirect_to team_login_url
      expect(response).to have_http_status(302)
    end
    it '登録されたプロフィール編集画面を表示できないこと' do
      get edit_team_team_path(@team)
      expect(response).to redirect_to team_login_url
      expect(response).to have_http_status(302)
      ### 下記でフレンドリーフォワーディングのテスト
      team_log_in_as(@team)
      expect(response).to redirect_to edit_team_team_path(@team)
    end
  end
  describe '認可のテスト' do
    before do
      @team = create(:team)
      team_log_in_as(@team)
      @other_team = create(:team)
    end
    describe 'プロフィール画面' do
      it '自チームのプロフィール画面を表示できること' do
        get team_team_path(@team)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
      it '他チームのプロフィール画面は表示できず自チームのプロフィール画面に遷移すること' do
        get team_team_path(@other_team)
        expect(response).to redirect_to team_team_url(@team)
        expect(response).to have_http_status(302)
      end
    end
    describe 'プロフィール編集画面' do
      it '自チームのプロフィール編集画面を表示できること' do
        get edit_team_team_path(@team)
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end
      it '他チームのプロフィール編集画面は表示できず自チームのプロフィール画面に遷移すること' do
        get edit_team_team_path(@other_team)
        expect(response).to redirect_to team_team_url(@team)
        expect(response).to have_http_status(302)
      end
    end
    describe 'プロフィール更新' do
      it '自チームのプロフィールを更新できること' do
        patch team_team_path(@team),
              params: { team: { account_name: 'valid',
                                display_name: '有効な表示名',
                                prefecture_code: '北海道',
                                email: 'valid@test.com' } }
        expect(response).to redirect_to team_team_url(@team)
        expect(response).to have_http_status(302)
      end
      it '無効な情報では更新に失敗すること' do
        patch team_team_path(@team),
              params: { team: { account_name: '',
                                display_name: '',
                                prefecture_code: '',
                                email: 'invalid@test' } }
        expect(response).to render_template(:edit)
      end
      it '他チームのプロフィールを更新できず自チームのプロフィール画面に遷移すること' do
        patch team_team_path(@other_team),
              params: { team: { account_name: 'valid',
                                display_name: '有効な表示名',
                                prefecture_code: '北海道',
                                email: 'valid@test.com' } }
        expect(response).to redirect_to team_team_url(@team)
        expect(response).to have_http_status(302)
      end
    end
  end
end
