require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group      = groups(:christmas_2020)
    @membership = @group.memberships.find_by(user: users(:monica))
    sign_in users(:monica)
  end

  test "#new" do
    get new_group_membership_url(@group)
    assert_response :ok
  end

  test "#create" do
    post group_memberships_url(@group), params: { membership: { email_addresses: [ 'rachel@drumroll.com', 'joey@drumroll.com', 'chandler@drumroll.com' ] } }
    assert_response :redirect
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

end
