class Player::SessionsController < ApplicationController
  include Player::SessionsHelper

  def new; end

  def create
    @player = Player.find_by(email: params[:session][:email]&.downcase)
    if @player && @player&.authenticate(params[:session][:password])
      player_log_in @player
      params[:session][:remember_me] == '1' ? remember_player(@player) : forget_player(@player)
      redirect_back_or player_player_url(@player)
    else
      flash.now[:danger] = 'メールアドレス・パスワードの組み合わせが違います'
      render 'new'
    end
  end

  def destroy
    player_log_out if player_logged_in?
    redirect_to root_url
  end
end
