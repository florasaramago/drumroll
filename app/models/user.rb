class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :groups, through: :memberships

  def admin?(group)
    membership(group).admin?
  end

  def membership(group)
    memberships.find_by(group: group)
  end
end
