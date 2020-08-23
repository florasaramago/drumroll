class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :exchanges

  delegate :name, to: :user

  scope :confirmed, -> { where(confirmed: true) }

  def confirm!
    update! confirmed: true
  end
end
