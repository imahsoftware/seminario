# AuthTrail — configuración manual requerida por authtrail 0.7.1+
# El modelo LoginActivity debe existir (ver app/models/login_activity.rb)
# La tabla login_activities debe existir en la base de datos.
AuthTrail.track_method = lambda do |data|
  login_activity = LoginActivity.new
  data.each do |k, v|
    login_activity.try("#{k}=", v)
  end
  login_activity.save!
end

AuthTrail.geocode = false
