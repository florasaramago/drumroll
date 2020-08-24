require 'test_helper'

class ExchangesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group = groups(:christmas_2019)
    sign_in users(:monica)
  end

  test "#create" do
    post group_exchanges_url(@group)
    assert_response :redirect
  end

  test "#show" do
    get group_exchange_url(@group, exchanges(:ross_joey_christmas_2019))
    assert_response :ok
  end
end
