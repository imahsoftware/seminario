require 'test_helper'

class IglesiascomunidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iglesiascomunidad = iglesiascomunidades(:one)
  end

  test "should get index" do
    get iglesiascomunidades_url
    assert_response :success
  end

  test "should get new" do
    get new_iglesiascomunidad_url
    assert_response :success
  end

  test "should create iglesiascomunidad" do
    assert_difference('Iglesiascomunidad.count') do
      post iglesiascomunidades_url, params: { iglesiascomunidad: { estado: @iglesiascomunidad.estado, iglesia_id: @iglesiascomunidad.iglesia_id, nombre: @iglesiascomunidad.nombre, user_act: @iglesiascomunidad.user_act, user_id: @iglesiascomunidad.user_id } }
    end

    assert_redirected_to iglesiascomunidad_url(Iglesiascomunidad.last)
  end

  test "should show iglesiascomunidad" do
    get iglesiascomunidad_url(@iglesiascomunidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_iglesiascomunidad_url(@iglesiascomunidad)
    assert_response :success
  end

  test "should update iglesiascomunidad" do
    patch iglesiascomunidad_url(@iglesiascomunidad), params: { iglesiascomunidad: { estado: @iglesiascomunidad.estado, iglesia_id: @iglesiascomunidad.iglesia_id, nombre: @iglesiascomunidad.nombre, user_act: @iglesiascomunidad.user_act, user_id: @iglesiascomunidad.user_id } }
    assert_redirected_to iglesiascomunidad_url(@iglesiascomunidad)
  end

  test "should destroy iglesiascomunidad" do
    assert_difference('Iglesiascomunidad.count', -1) do
      delete iglesiascomunidad_url(@iglesiascomunidad)
    end

    assert_redirected_to iglesiascomunidades_url
  end
end
