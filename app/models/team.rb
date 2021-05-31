class Team < ApplicationRecord
  attr_accessor :remember_token

  before_save { email.downcase! }

  A_NAME_MIN = 4
  A_NAME_MAX = 15
  D_NAME_MAX = 50
  EMAIL_MAX = 255
  PASSWORD_MIN = 6
  VALID_A_NAME_REGEX = /[0-9a-zA-Z_]{4,15}/i.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum prefecture_code: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14,
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18, 山梨県: 19, 長野県: 20,
    岐阜県: 21, 静岡県: 22, 愛知県: 23, 三重県: 24,
    滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46,
    沖縄県: 47
  }

  validates :account_name, presence: true, length: { in: A_NAME_MIN..A_NAME_MAX }, format: { with: VALID_A_NAME_REGEX }, uniqueness: true
  validates :display_name, presence: true, length: { maximum: D_NAME_MAX }
  validates :prefecture_code, presence: true
  validates :email, presence: true, length: { maximum: EMAIL_MAX }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: PASSWORD_MIN }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにチームをデータベースに記憶する
  def remember_team
    self.remember_token = Player.new_token
    update_attribute(:remember_digest, Team.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 選手のログイン情報を破棄する
  def forget_team
    update_attribute(:remember_digest, nil)
  end
end
