module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end



  def irregular_types(type)
    case type
    when 'alert'
      'danger'
    when 'notice'
      'warning'
    else
      type
    end
  end


  def log_actions(value)
    if value == 'destroy'
      "Eliminar"
    elsif value == 'create'
      "Crear"
    elsif value == 'update'
      "Actualizar"
    end
  end

  def select_user
    return is_select_user
  end



  def select_estado
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end


  def select_estado_portafolios
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end


  def select_nivel
    [
      ["GESTION", 1],
      ["CARGUES", 6],
      ["PROCESOS", 2],
      ["PARAMETRIZACIÓN", 3],
      ["SEGURIDAD", 4],
      ["PARAMETRIZACIÓN EDUCACIÓN", 5]
    ]
  end

  def select_prioridad
    [
      ["EXTREMO", "EXTREMO"],
      ["ALTA", "ALTA"],
      ["MEDIA", "MEDIA"],
      ["BAJA", "BAJA"]
    ]
  end

  def select_formato
    [
      ["PDF", "PDF"],
      ["EXCEL", "EXCEL"]
    ]
  end

  def select_calificacion_soporte2
    [
      ['3', 3],
      ['2', 2],
      ['1', 1]
    ]
  end

  def select_niveleducativo
    [
      ["TECNICO", "TECNICO"],
      ["TECNOLOGICO", "TECNOLOGICO"],
      ["UNIVERSITARIO", "UNIVERSITARIO"],
      ["POSGRADO", "POSGRADO"]
    ]
  end

  def select_periodicidad
    [
      ["SEMESTRAL", "SEMESTRAL"],
      ["ANUAL", "ANUAL"]
    ]
  end

  def select_rangocalendar
    [2017, 2018]
  end

  def select_formapagohelena
    [
      ["EFECTIVO", "EFECTIVO"],
      ["CONSIGNACION", "CONSIGNACION"]
    ]
  end

  def select_tiposgestion
    [
      ['COBRANZA', 'COBRANZA'],
      ['VIRTUAL', 'VIRTUAL']
    ]
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def camponumerico(valor)
    number_to_currency(valor, precision: 2, unit: "", delimiter: ".")
  end

  def camponumerico2(valor)
    number_to_currency(valor, precision: 0, unit: "", delimiter: ".")
  end

  def camponumerico3(valor)
    number_to_currency(valor, precision: 3, unit: "", delimiter: ".")
  end

  def camponumerico4(valor)
    number_to_currency(valor, precision: 1, unit: "", delimiter: ".")
  end

  def select_perumunicipio
    return is_select_perumunicipio
  end


  def user_avatar_perfil(params)
    if params.avatar.present?
      image_tag params.avatar.url(:original), alt: "User profile picture", class: "profile-user-img img-responsive", height: '100', width: '100'
    else
      image_tag 'no_foto.png', class: "profile-user-img img-responsive", height: '100', width: '100'
    end
  end


  def select_campo
    iparametros_campos = Iparametro.distinct.pluck(:campo)
    opciones = iparametros_campos.map { |campo| [campo, campo] }

    opciones += [
      ["arl","arl"],
      ["banco","banco"],
      ["caja_compensacion","caja_compensacion"],
      ["cargo","cargo"],
      ["documentos_contratacion","documentos_contratacion"],
      ["documentos_personales","documentos_personales"],
      ["documentos_post-contratacion","documentos_post-contratacion"],
      ["epp","epp"],
      ["eps","eps"],
      ["estado_civil","estado_civil"],
      ["estrato","estrato"],
      ["fondo_pension","fondo_pension"],
      ["genero","genero"],
      ["grupo_nomina","grupo_nomina"],
      ["nivel_educacion","nivel_educacion"],
      ["parentesco","parentesco"],
      ["proceso","proceso"],
      ["situacion_especial","situacion_especial"],
      ["tipo_contrato","tipo_contrato"],
      ["tipo_cuenta","tipo_cuenta"],
      ["tipo_identificacion","tipo_identificacion"],
      ["tipo_identificacion_proveedor","tipo_identificacion_proveedor"]
    ]

    opciones
  end

  def select_campo_asignado
    array = []
    Usersparametro.where("user_id = #{is_admin}").each do |parametro|
      array << [parametro.campo.to_s, parametro.campo.to_s]
    end
    return array
  end

  def select_tipometodourl
    [
      ['GET', 'GET'],
      ['POST', 'POST']
    ]
  end

  def select_sinopayu
    [
      ['SI', 1],
      ['NO', 0]
    ]
  end

  def select_sinocorto
    [
      ['SI', 'S'],
      ['NO', 'N']
    ]
  end

  def select_tipoconsulta
    [
      ["SUPERVISOR", "SUPERVISOR"],
      ["ADMINISTRADOR", "ADMINISTRADOR"],
      ["GESTION", "GESTION"],
      ["PERSONA", "PERSONA"],
      ["CONTRATO", "CONTRATO"],
      ["CANDIDATO", "CANDIDATO"],
      ["TODO", "TODO"]
    ]
  end

  def paginate(collection, params = {})
    will_paginate collection, params.merge(:renderer => RemoteLinkPaginationHelper::LinkRenderer)
  end
end
