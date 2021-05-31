class Team::TeamsController < ApplicationController
  include Team::SessionsHelper

  before_action :logged_in_team, only: [:show, :edit, :update]
  before_action :correct_team, only: [:show, :edit, :update]

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      team_log_in @team
      flash[:success] = complete_message
      redirect_to team_team_url(@team)
    else
      render 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      flash[:success] = updateed_message
      redirect_to team_team_url(@team)
    else
      render 'edit'
    end
  end

  private

  def team_params
    params.require(:team).permit(:account_name, :display_name, :prefecture_code, :email, :password, :password_confirmation)
  end

  ### start before action ###
  def logged_in_team
    return if team_logged_in?

    store_location
    flash[:danger] = 'ログインしてください'
    redirect_to team_login_url
  end

  def correct_team
    @team = Team.find(params[:id])
    redirect_to team_team_path(current_team) unless current_team?(@team)
  end
  ### end before action ###

  def complete_message
    'プレイヤー登録が完了しました'
  end

  def updateed_message
    'プレイヤー情報を更新しました'
  end
end
