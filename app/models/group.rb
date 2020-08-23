class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :exchanges, dependent: :destroy

  def admin
    memberships.find_by(admin: true)
  end

  def can_draw_names?
    !names_drawn? && memberships.count > 2 && memberships.confirmed.all?
  end
end
