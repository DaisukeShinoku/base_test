47.times do |n|
  account_name = "team#{n + 1}"
  email = "#{account_name}@example.com"
  display_name = "チーム名#{n + 1}"
  prefecture_code = n + 1

  team = Team.find_or_initialize_by(email: email)

  next unless team.new_record?

  team.account_name = account_name
  team.display_name = display_name
  team.prefecture_code = prefecture_code
  team.password = 'password'
  team.save!
end

puts "teams = #{Team.count}"
