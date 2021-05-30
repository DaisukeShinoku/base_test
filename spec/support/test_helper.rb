module TestHelper
  def is_player_logged_in?
    !session[:player_id].nil?
  end
end
