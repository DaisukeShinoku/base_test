# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_530_095_513) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'players', comment: 'プレイヤー', force: :cascade do |t|
    t.string 'account_name', limit: 15, null: false, comment: 'アカウント名'
    t.string 'display_name', limit: 50, null: false, comment: 'プロフィール名'
    t.integer 'prefecture_code', comment: '都道府県コード'
    t.string 'email', null: false, comment: 'メールアドレス'
    t.string 'password_digest', null: false, comment: 'パスワード'
    t.text 'profile', comment: 'プロフィール文'
    t.string 'image', comment: 'プロフィール画像'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'remember_digest'
    t.index ['account_name'], name: 'index_players_on_account_name', unique: true
    t.index ['email'], name: 'index_players_on_email', unique: true
  end
end
