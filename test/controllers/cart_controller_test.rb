require "test_helper"

class CartControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cart_show_url
    assert_response :success
  end

  test "should get checkout" do
    get cart_checkout_url
    assert_response :success
  end

  test "should get purchase_history" do
    get cart_purchase_history_url
    assert_response :success
  end
end
