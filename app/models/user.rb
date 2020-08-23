class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :groups, through: :memberships
end
