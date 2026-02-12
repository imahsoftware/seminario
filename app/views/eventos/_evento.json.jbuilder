json.extract! evento, :id, :guid, :iglesia_id, :iglesiascomunidad_id, :tiposevento_id, :fecha_inicio, :fecha_fin, :detalle, :estado, :user_id, :user_act, :created_at, :updated_at
json.url evento_url(evento, format: :json)
