class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, comment: 'チーム' do |t|
      t.string :account_name, null: false, limit: 15, comment: 'アカウント名'
      t.string :display_name, null: false, limit: 50, comment: 'プロフィール名'
      t.string :email, null: false, comment: 'メールアドレス'
      t.string :password_digest, null: false, comment: 'パスワード'
      t.integer :prefecture_code, comment: '都道府県コード'
      t.string :city, comment: '市町村'
      t.string :street, comment: '番地'
      t.string :latitude, comment: '緯度'
      t.string :longitude, comment: '経度'
      t.string :phone_number, comment: '電話番号'
      t.integer :category_id, comment: 'カテゴリーID'
      t.text :profile, comment: 'プロフィール文'
      t.string :image, comment: 'プロフィール画像'
      t.string :remember_digest
      t.timestamps
    end
    add_index :teams, :account_name, unique: true
    add_index :teams, :email, unique: true
  end
end
