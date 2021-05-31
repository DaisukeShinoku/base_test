module Team::SessionsHelper
  def team_log_in(team)
    session[:team_id] = team.id
  end

  # チームのセッションを永続的にする
  def remember_team(team)
    team.remember_team
    cookies.permanent.signed[:team_id] = team.id
    cookies.permanent[:remember_token] = team.remember_token
  end

  def current_team?(team)
    team == current_team
  end

  def current_team
    if (team_id = session[:team_id])
      @current_team ||= Team.find_by(id: team_id)
    elsif (team_id = cookies.signed[:team_id])
      team = Team.find_by(id: team_id)
      if team && team&.authenticated?(cookies[:remember_token])
        log_in team
        @current_team = team
      end
    end
  end

  def team_logged_in?
    !current_team.nil?
  end

  # 永続的セッションを破棄する
  def forget_team(team)
    team.forget_team
    cookies.delete(:team_id)
    cookies.delete(:remember_token)
  end

  def team_log_out
    forget_team(current_team)
    session.delete(:team_id)
    @current_team = nil
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
