require 'test_helper'

class IglesiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iglesia = iglesias(:one)
  end

  test "should get index" do
    get iglesias_url
    assert_response :success
  end

  test "should get new" do
    get new_iglesia_url
    assert_response :success
  end

  test "should create iglesia" do
    assert_difference('Iglesia.count') do
      post iglesias_url, params: { iglesia: { direccion: @iglesia.direccion, email: @iglesia.email, nombre: @iglesia.nombre, presbitero: @iglesia.presbitero, telefono: @iglesia.telefono, user_act: @iglesia.user_act, user_id: @iglesia.user_id } }
    end

    assert_redirected_to iglesia_url(Iglesia.last)
  end

  test "should show iglesia" do
    get iglesia_url(@iglesia)
    assert_response :success
  end

  test "should get edit" do
    get edit_iglesia_url(@iglesia)
    assert_response :success
  end

  test "should update iglesia" do
    patch iglesia_url(@iglesia), params: { iglesia: { direccion: @iglesia.direccion, email: @iglesia.email, nombre: @iglesia.nombre, presbitero: @iglesia.presbitero, telefono: @iglesia.telefono, user_act: @iglesia.user_act, user_id: @iglesia.user_id } }
    assert_redirected_to iglesia_url(@iglesia)
  end

  test "should destroy iglesia" do
    assert_difference('Iglesia.count', -1) do
      delete iglesia_url(@iglesia)
    end

    assert_redirected_to iglesias_url
  end
end
