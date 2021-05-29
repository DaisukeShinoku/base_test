class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players, comment: 'プレイヤー' do |t|
      t.string :account_name, null: false, limit: 15, comment: 'アカウント名'
      t.string :display_name, null: false, limit: 50, comment: 'プロフィール名'
      t.integer :prefecture_code, comment: '都道府県コード'
      t.string :email, null: false, comment: 'メールアドレス'
      t.string :password_digest, null: false, comment: 'パスワード'
      t.text :profile, comment: 'プロフィール文'
      t.string :image, comment: 'プロフィール画像'

      t.timestamps
    end
    add_index :players, :account_name, unique: true
    add_index :players, :email, unique: true
  end
end
