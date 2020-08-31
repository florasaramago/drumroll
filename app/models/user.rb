class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :groups, through: :memberships

  has_one_attached :avatar

  def admin?(group)
    membership(group).admin?
  end

  def membership(group)
    memberships.find_by(group: group)
  end
end
