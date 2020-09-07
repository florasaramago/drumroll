require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group      = groups(:christmas_2020)
    @membership = @group.memberships.find_by(user: users(:monica))
    @new_group  = users(:monica).groups.create!(name: "Christmas 2018", creator: users(:monica))
    sign_in users(:monica)
  end

  test "#index as admin" do
    get group_memberships_url(@group)
    assert_response :ok
  end

  test "#index as a non-admin" do
    sign_in users(:rachel)

    get group_memberships_url(@group)
    assert_redirected_to group_url(@group)
  end

  test "#index as an admin after names are drawn" do
    group = groups(:christmas_2019)

    assert group.names_drawn?

    get group_memberships_url(group)
    assert_redirected_to group_url(group)
  end

  test "#new" do
    get new_group_membership_url(@group)
    assert_response :ok
  end

  test "#create with addresses separated by commas" do
    assert_difference -> { @new_group.memberships.count }, +3 do
      post group_memberships_url(@new_group), params: { email_addresses: "rachel@drumroll.com, joey@drumroll.com, chandler@drumroll.com" }
      assert_redirected_to group_url(@new_group)
      assert_created_memberships(@new_group, ["rachel@drumroll.com", "joey@drumroll.com", "chandler@drumroll.com"])
    end
  end

  test "#create with addresses separated by spaces" do
    assert_difference -> { @new_group.memberships.count }, +3 do
      post group_memberships_url(@new_group), params: { email_addresses: "rachel@drumroll.com joey@drumroll.com chandler@drumroll.com" }
      assert_redirected_to group_url(@new_group)
      assert_created_memberships(@new_group, ["rachel@drumroll.com", "joey@drumroll.com", "chandler@drumroll.com"])
    end
  end

  test "#create with addresses separated by a mix of spaces and commas" do
    assert_difference -> { @new_group.memberships.count }, +3 do
      post group_memberships_url(@new_group), params: { email_addresses: "rachel@drumroll.com, joey@drumroll.com chandler@drumroll.com" }
      assert_redirected_to group_url(@new_group)
      assert_created_memberships(@new_group, ["rachel@drumroll.com", "joey@drumroll.com", "chandler@drumroll.com"])
    end
  end

  test "#create with addresses that include a non-user" do
    assert_difference -> { @new_group.memberships.count }, +2 do
      post group_memberships_url(@new_group), params: { email_addresses: "rachel@drumroll.com, someone@drumroll.com" }
      assert_redirected_to group_url(@new_group)
      assert_created_memberships(@new_group, ["rachel@drumroll.com", "someone@drumroll.com"])
    end
  end

  test "#create with a duplicated address" do
    assert_difference -> { @new_group.memberships.count }, +3 do
      post group_memberships_url(@new_group), params: { email_addresses: "rachel@drumroll.com, joey@drumroll.com, rachel@drumroll.com, chandler@drumroll.com" }
      assert_redirected_to group_url(@new_group)
    end
  end

  test "#create with empty address list" do
    assert_no_difference -> { @new_group.memberships.count } do
      post group_memberships_url(@new_group), params: { email_addresses: "" }
      assert_redirected_to group_url(@new_group)
    end
  end

  test "#show" do
    get group_membership_url(@group, @membership)
    assert_response :ok
  end

  test "#edit" do
    get edit_group_membership_url(@group, @membership)
    assert_response :ok
  end

  test "#update" do
    put group_membership_url(@group, @membership), params: { membership: { wishlist: "A unicorn." }}
    assert_response :redirect
  end

  test "#destroy" do
    delete group_membership_url(@group, @membership)
    assert_response :redirect
  end

  private
    def assert_created_memberships(group, members)
      members.each do |email_address|
        assert_not_nil group.memberships.find_by(user: User.find_by(email: email_address))
      end
    end
end
