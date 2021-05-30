class Player::PlayersController < ApplicationController
  include Player::SessionsHelper

  before_action :logged_in_player, only: [:show, :edit, :update]
  before_action :correct_player, only: [:show, :edit, :update]

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      player_log_in @player
      flash[:success] = complete_message
      redirect_to player_player_url(@player)
    else
      render 'new'
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update(player_params)
      flash[:success] = updateed_message
      redirect_to player_player_url(@player)
    else
      render 'edit'
    end
  end

  private

  def player_params
    params.require(:player).permit(:account_name, :display_name, :prefecture_code, :email, :password, :password_confirmation)
  end

  ### start before action ###
  def logged_in_player
    return if player_logged_in?

    store_location
    flash[:danger] = 'ログインしてください'
    redirect_to player_login_url
  end

  def correct_player
    @player = Player.find(params[:id])
    redirect_to player_player_path(current_player) unless current_player?(@player)
  end
  ### end before action ###

  def complete_message
    'プレイヤー登録が完了しました'
  end

  def updateed_message
    'プレイヤー情報を更新しました'
  end
end
