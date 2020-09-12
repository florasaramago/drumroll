class Group < ApplicationRecord
  include Invitable

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :exchanges, dependent: :destroy
  belongs_to :creator, class_name: 'User'

  after_create_commit :set_admin

  def admins
    memberships.where(admin: true)
  end

  def can_draw_names?
    !names_drawn? && memberships.count > 2 && all_members_confirmed?
  end

  def draw_names
    Draw.new(self).perform
  end

  def receiver_for(giver)
    exchanges.find_by giver: giver.membership(self)
  end

  def notify_admins_if_ready_to_draw
    if can_draw_names?
      admins.each do |admin|
        GroupMailer.ready_to_draw(self, admin.user).deliver
      end
    end
  end

  private
    def set_admin
      memberships.find_by(user: creator).update! admin: true, confirmed: true
    end

    def all_members_confirmed?
      memberships.where(confirmed: false).none?
    end
end
