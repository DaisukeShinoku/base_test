47.times do |n|
  account_name = "player#{n + 1}"
  email = "#{account_name}@example.com"
  display_name = "選手名#{n + 1}"
  prefecture_code = n + 1

  player = Player.find_or_initialize_by(email: email)

  next unless player.new_record?

  player.account_name = account_name
  player.display_name = display_name
  player.prefecture_code = prefecture_code
  player.password = 'password'
  player.save!
end

puts "players = #{Player.count}"
