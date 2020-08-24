class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :exchanges, dependent: :destroy
  belongs_to :creator, class_name: 'User'

  after_create_commit :set_admin

  def admin
    memberships.find_by(admin: true)
  end

  def can_draw_names?
    !names_drawn? && memberships.count > 2 && memberships.confirmed.all?
  end

  private
    def set_admin
      memberships.find_by(user: creator).update! admin: true, confirmed: true
    end
end
