require 'test_helper'

class EventosusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eventosuser = eventosusers(:one)
  end

  test "should get index" do
    get eventosusers_url
    assert_response :success
  end

  test "should get new" do
    get new_eventosuser_url
    assert_response :success
  end

  test "should create eventosuser" do
    assert_difference('Eventosuser.count') do
      post eventosusers_url, params: { eventosuser: { evento_id: @eventosuser.evento_id, user_administra: @eventosuser.user_administra, user_id: @eventosuser.user_id } }
    end

    assert_redirected_to eventosuser_url(Eventosuser.last)
  end

  test "should show eventosuser" do
    get eventosuser_url(@eventosuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_eventosuser_url(@eventosuser)
    assert_response :success
  end

  test "should update eventosuser" do
    patch eventosuser_url(@eventosuser), params: { eventosuser: { evento_id: @eventosuser.evento_id, user_administra: @eventosuser.user_administra, user_id: @eventosuser.user_id } }
    assert_redirected_to eventosuser_url(@eventosuser)
  end

  test "should destroy eventosuser" do
    assert_difference('Eventosuser.count', -1) do
      delete eventosuser_url(@eventosuser)
    end

    assert_redirected_to eventosusers_url
  end
end
