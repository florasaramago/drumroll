class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :exchanges

  has_rich_text :wishlist

  delegate :name, to: :user

  after_update :notify_group, if: :confirmed_previously_changed?

  scope :confirmed, -> { where(confirmed: true) }

  def confirm!
    update! confirmed: true
  end

  private
    def notify_group
      group.notify_admins_if_ready_to_draw
    end
end
