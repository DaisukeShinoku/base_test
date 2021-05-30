module Player::SessionsHelper
  def player_log_in(player)
    session[:player_id] = player.id
  end

  # 選手のセッションを永続的にする
  def remember_player(player)
    player.remember_player
    cookies.permanent.signed[:player_id] = player.id
    cookies.permanent[:remember_token] = player.remember_token
  end

  def current_player?(player)
    player == current_player
  end

  def current_player
    if (player_id = session[:player_id])
      @current_player ||= Player.find_by(id: player_id)
    elsif (player_id = cookies.signed[:player_id])
      player = Player.find_by(id: player_id)
      if player && player&.authenticated?(cookies[:remember_token])
        log_in player
        @current_player = player
      end
    end
  end

  def player_logged_in?
    !current_player.nil?
  end

  # 永続的セッションを破棄する
  def forget_player(player)
    player.forget_player
    cookies.delete(:player_id)
    cookies.delete(:remember_token)
  end

  def player_log_out
    forget_player(current_player)
    session.delete(:player_id)
    @current_player = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
