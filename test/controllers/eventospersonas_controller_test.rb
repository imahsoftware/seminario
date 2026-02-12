require 'test_helper'

class EventospersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eventospersona = eventospersonas(:one)
  end

  test "should get index" do
    get eventospersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_eventospersona_url
    assert_response :success
  end

  test "should create eventospersona" do
    assert_difference('Eventospersona.count') do
      post eventospersonas_url, params: { eventospersona: { acepta_cultura: @eventospersona.acepta_cultura, acepta_politica: @eventospersona.acepta_politica, acudiente_apellido: @eventospersona.acudiente_apellido, acudiente_celular: @eventospersona.acudiente_celular, acudiente_codigorec: @eventospersona.acudiente_codigorec, acudiente_codigoval: @eventospersona.acudiente_codigoval, acudiente_email: @eventospersona.acudiente_email, acudiente_firma: @eventospersona.acudiente_firma, acudiente_identificacion: @eventospersona.acudiente_identificacion, acudiente_nombre: @eventospersona.acudiente_nombre, apellido: @eventospersona.apellido, celular: @eventospersona.celular, direccion: @eventospersona.direccion, email: @eventospersona.email, estado_civil: @eventospersona.estado_civil, evento_id: @eventospersona.evento_id, fecha_nacimiento: @eventospersona.fecha_nacimiento, identificacion: @eventospersona.identificacion, nombre: @eventospersona.nombre, sexo: @eventospersona.sexo } }
    end

    assert_redirected_to eventospersona_url(Eventospersona.last)
  end

  test "should show eventospersona" do
    get eventospersona_url(@eventospersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_eventospersona_url(@eventospersona)
    assert_response :success
  end

  test "should update eventospersona" do
    patch eventospersona_url(@eventospersona), params: { eventospersona: { acepta_cultura: @eventospersona.acepta_cultura, acepta_politica: @eventospersona.acepta_politica, acudiente_apellido: @eventospersona.acudiente_apellido, acudiente_celular: @eventospersona.acudiente_celular, acudiente_codigorec: @eventospersona.acudiente_codigorec, acudiente_codigoval: @eventospersona.acudiente_codigoval, acudiente_email: @eventospersona.acudiente_email, acudiente_firma: @eventospersona.acudiente_firma, acudiente_identificacion: @eventospersona.acudiente_identificacion, acudiente_nombre: @eventospersona.acudiente_nombre, apellido: @eventospersona.apellido, celular: @eventospersona.celular, direccion: @eventospersona.direccion, email: @eventospersona.email, estado_civil: @eventospersona.estado_civil, evento_id: @eventospersona.evento_id, fecha_nacimiento: @eventospersona.fecha_nacimiento, identificacion: @eventospersona.identificacion, nombre: @eventospersona.nombre, sexo: @eventospersona.sexo } }
    assert_redirected_to eventospersona_url(@eventospersona)
  end

  test "should destroy eventospersona" do
    assert_difference('Eventospersona.count', -1) do
      delete eventospersona_url(@eventospersona)
    end

    assert_redirected_to eventospersonas_url
  end
end
