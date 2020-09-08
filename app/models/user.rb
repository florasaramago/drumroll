class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :groups, through: :memberships

  has_one_attached :avatar

  def name
    super.presence || email
  end

  def admin?(group)
    membership(group).admin?
  end

  def membership(group)
    memberships.find_by(group: group)
  end

  def invitable_contacts_for(group)
    groups.flat_map(&:memberships).flat_map(&:user).uniq - group.memberships.flat_map(&:user)
  end
end
