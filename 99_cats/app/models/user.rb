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


  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    save!
    return self.session_token
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if !user

    user.is_password?(password) ? user : nil
  end

end
