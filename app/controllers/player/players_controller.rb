class Player::PlayersController < ApplicationController
  include Player::SessionsHelper

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      log_in @player
      flash[:success] = complete_message
      redirect_to player_player_path(@player)
    else
      render 'new'
    end
  end

  private

  def player_params
    params.require(:player).permit(:account_name, :display_name, :prefecture_code, :email, :password, :password_confirmation)
  end

  def complete_message
    'プレイヤー登録が完了しました'
  end
end
