require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  setup do
    @group = groups(:christmas_2020)
    @new_group = create_new_group
  end

  test "a group can't draw names when it has less than 2 members" do
    assert_not @group.memberships.count > 2
    assert_not @group.can_draw_names?
  end

  test "a group can't draw names unless all members are confirmed" do
    @group.memberships.create! user: users(:phoebe), admin: false

    assert @group.memberships.count > 2
    assert_not_empty @group.memberships.where(confirmed: false)
    assert_not @group.can_draw_names?
  end

  test "a group can draw names when it has more than 2 members, all confirmed" do
    assert @new_group.can_draw_names?
  end

  test "draw names" do
    monica = users(:monica).membership(@new_group)
    rachel = users(:rachel).membership(@new_group)
    phoebe = users(:phoebe).membership(@new_group)

    assert_difference -> { @new_group.exchanges.count }, +3 do
      @new_group.draw_names
    end

    assert @new_group.exchanges.where(giver: monica, receiver: [ rachel, phoebe ]).any?
    assert @new_group.exchanges.where(giver: rachel, receiver: [ monica, phoebe ]).any?
    assert @new_group.exchanges.where(giver: phoebe, receiver: [ rachel, monica ]).any?
  end

  private
    def create_new_group
      users(:monica).groups.create!(name: "Women", creator: users(:monica)).tap do |group|
        group.memberships.create! user: users(:rachel), admin: false
        group.memberships.create! user: users(:phoebe), admin: false
        group.memberships.each(&:confirm!)
      end
    end
end
