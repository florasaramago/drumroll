class Exchange < ApplicationRecord
  belongs_to :group
  belongs_to :giver,    class_name: 'Membership'
  belongs_to :receiver, class_name: 'Membership'
end
