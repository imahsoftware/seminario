class CreateSmsLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :sms_logs do |t|
      t.integer :evento_id,         null: true
      t.integer :eventospersona_id, null: true
      t.string  :tipo,                  limit: 30,  null: false  # AUTORIZACION_MENOR | CREDENCIALES
      t.string  :destinatario_nombre,   limit: 200
      t.string  :destinatario_celular,  limit: 20
      t.string  :identificacion,        limit: 30
      t.text    :mensaje
      t.string  :url_enviada,           limit: 500
      t.string  :estado,                limit: 10   # ENVIADO | ERROR
      t.integer :codigo_http
      t.text    :respuesta_servicio

      t.timestamps
    end

    add_index :sms_logs, :tipo
    add_index :sms_logs, :estado
    add_index :sms_logs, :destinatario_celular
    add_index :sms_logs, :identificacion
    add_index :sms_logs, :created_at
  end
end
