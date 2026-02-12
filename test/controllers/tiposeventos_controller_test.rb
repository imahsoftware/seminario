require 'test_helper'

class TiposeventosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposevento = tiposeventos(:one)
  end

  test "should get index" do
    get tiposeventos_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposevento_url
    assert_response :success
  end

  test "should create tiposevento" do
    assert_difference('Tiposevento.count') do
      post tiposeventos_url, params: { tiposevento: { descripcion: @tiposevento.descripcion, estado: @tiposevento.estado, user_act: @tiposevento.user_act, user_id: @tiposevento.user_id } }
    end

    assert_redirected_to tiposevento_url(Tiposevento.last)
  end

  test "should show tiposevento" do
    get tiposevento_url(@tiposevento)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposevento_url(@tiposevento)
    assert_response :success
  end

  test "should update tiposevento" do
    patch tiposevento_url(@tiposevento), params: { tiposevento: { descripcion: @tiposevento.descripcion, estado: @tiposevento.estado, user_act: @tiposevento.user_act, user_id: @tiposevento.user_id } }
    assert_redirected_to tiposevento_url(@tiposevento)
  end

  test "should destroy tiposevento" do
    assert_difference('Tiposevento.count', -1) do
      delete tiposevento_url(@tiposevento)
    end

    assert_redirected_to tiposeventos_url
  end
end
