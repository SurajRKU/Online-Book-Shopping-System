class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:username]
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_many :transactions, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
