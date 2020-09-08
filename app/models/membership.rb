class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :exchanges

  has_rich_text :wishlist

  delegate :name, to: :user

  scope :confirmed, -> { where(confirmed: true) }

  def confirm!
    update! confirmed: true
  end
end
