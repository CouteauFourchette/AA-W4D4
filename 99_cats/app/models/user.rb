class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password, length: { in: (6..20), allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  has_many :cat_requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

  has_many :tokens


  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    if @token
      session_tok = SessionToken.find_by(token: @token)
      SessionToken.create(user_id: self.id, token: SecureRandom.urlsafe_base64) if !session_tok
    else
      @token = SessionToken.create(user_id: self.id, token: SecureRandom.urlsafe_base64)
    end
  end

  def reset_session_token!
    token = SessionToken.find_by(token: session[:session_token])
    token.destroy
    token = SessionToken.new(user_id: self.id, token: SecureRandom.urlsafe_base64)
    return token.token
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if !user

    user.is_password?(password) ? user : nil
  end

end
