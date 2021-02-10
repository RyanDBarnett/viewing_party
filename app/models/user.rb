class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :viewers, dependent: :destroy
  has_many :parties, through: :viewers

  has_many :inverse_friendships,
            class_name: 'Friendship',
            foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

  has_secure_password
  validates :password, presence: true, allow_blank: false
  validates :password, confirmation: { case_sensitive: true }

  def all_friends
    friends + inverse_friends
  end
end
