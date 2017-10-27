class SessionToken < ApplicationRecord
  validates :user_id, :token, null: false

  belongs_to :user
end
