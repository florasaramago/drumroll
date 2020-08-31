class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :exchanges

  scope :confirmed, -> { where(confirmed: true) }

  def confirm!
    update! confirmed: true
  end

  def name
    user.name || user.email
  end
end
