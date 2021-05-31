module TestHelper
  def is_player_logged_in?
    !session[:player_id].nil?
  end

  def player_log_in_as(player, remember_me: '1')
    post player_login_path, params: { session: {
      email: player.email,
      password: player.password,
      remember_me: remember_me
    } }
  end

  def is_team_logged_in?
    !session[:team_id].nil?
  end

  def team_log_in_as(team, remember_me: '1')
    post team_login_path, params: { session: {
      email: team.email,
      password: team.password,
      remember_me: remember_me
    } }
  end
end
