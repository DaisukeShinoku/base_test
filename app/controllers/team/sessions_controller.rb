class Team::SessionsController < ApplicationController
  include Team::SessionsHelper

  def new; end

  def create
    @team = Team.find_by(email: params[:session][:email]&.downcase)
    if @team && @team&.authenticate(params[:session][:password])
      team_log_in @team
      params[:session][:remember_me] == '1' ? remember_team(@team) : forget_team(@team)
      redirect_back_or team_team_url(@team)
    else
      flash.now[:danger] = 'メールアドレス・パスワードの組み合わせが違います'
      render 'new'
    end
  end

  def destroy
    team_log_out if team_logged_in?
    redirect_to root_url
  end
end
