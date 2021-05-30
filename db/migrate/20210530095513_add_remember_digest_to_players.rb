class AddRememberDigestToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :remember_digest, :string
  end
end
