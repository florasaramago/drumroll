require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  setup do
    @group = groups(:christmas_2020)
  end

  test "a group can't draw names when it has less than 2 members" do
    assert_not @group.memberships.count > 2
    assert_not @group.can_draw_names?
  end

  test "a group can't draw names unless all members are confirmed" do
    assert_not_empty @group.memberships.where(confirmed: false)
    assert_not @group.can_draw_names?
  end

  test "a group can draw names when it has more than 2 members, all confirmed" do
    group = users(:monica).groups.create! name: "Women", creator: users(:monica)
    group.memberships.create! user: users(:rachel), admin: false
    group.memberships.create! user: users(:phoebe), admin: false
    group.memberships.each(&:confirm!)

    assert group.can_draw_names?
  end
end
