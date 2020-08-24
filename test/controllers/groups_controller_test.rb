require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group = groups(:christmas_2019)
    sign_in users(:monica)
  end

  test "#index" do
    get groups_url
    assert_response :ok
  end

  test "#new" do
    get new_group_url
    assert_response :ok
  end

  test "#show" do
    get group_url(@group)
    assert_response :ok
  end

  test "#create" do
    post groups_url, params: { group: { name: "Easter 2020", description: "Not happening." } }
    assert_response :redirect
  end

  test "#edit" do
    get edit_group_url(@group)
    assert_response :ok
  end

  test "#update" do
    put group_url(@group), params: { group: { description: "Changing the description." } }
    assert_response :redirect
  end

  test "#destroy" do
    delete group_url(@group)
    assert_response :redirect
  end

end
