class Player::SessionsController < ApplicationController
  include Player::SessionsHelper

  def new; end

  def create
    player = Player.find_by(email: params[:session][:email]&.downcase)
    if player && player&.authenticate(params[:session][:password])
      log_in player
      redirect_to player_player_path(player)
    else
      flash.now[:danger] = 'メールアドレス・パスワードの組み合わせが違います'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
