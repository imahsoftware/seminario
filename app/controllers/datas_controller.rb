class DatasController < ApplicationController
  require 'csv'
  require 'find'
  require 'rubygems'
  # require 'zip'
  require 'axlsx'

  layout :determine_layout

  def informedat
    idReport = params[:infgrupo_id] rescue nil
    idContrato = params[:contrato_id] rescue nil
    if idReport == 36
      dato1 = params[:ubicacion][:mes].to_s rescue nil
      dato2 = params[:ubicacion][:anno].to_s rescue nil
      dato3 = params[:ubicacion][:tiposnovedad].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != "" and dato3.to_s != ""
        varid = dato2 + '-' + dato1 + '-' + dato3
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      elsif dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: 40, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 37
      dato1 = params[:ubicacion][:mes37].to_s rescue nil
      dato2 = params[:ubicacion][:anno37].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 39
      dato1 = params[:ubicacion][:mes39].to_s rescue nil
      dato2 = params[:ubicacion][:anno39].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 41
      dato1 = params[:ubicacion][:periodosliquidacion_id].to_s rescue nil
      idContrato = params[:ubicacion][:contratoid_41].to_s rescue nil
      if dato1.to_s != "" and idContrato.to_s != ""
        varid = idContrato.to_s + '-' + dato1.to_s
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 47
      idContrato = params[:ubicacion][:contratoid].to_s rescue nil
      # if idContrato.to_s == ""
      #  idContrato = 24
      # end
      dato1 = params[:ubicacion][:mes47].to_s rescue nil
      dato2 = params[:ubicacion][:anno47].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + dato1
        ActiveRecord::Base.connection.execute("CALL prc_informe_terminal('#{idContrato}','#{varid}')")
        redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 51
      dato2 = params[:ubicacion][:anno51].to_s rescue nil
      if dato2.to_s != ""
        varid = dato2
        ActiveRecord::Base.connection.execute("CALL prc_informe_terminal(-1,'#{varid}')")
        redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 53
      dato1 = params[:ubicacion][:mes53].to_s rescue nil
      dato2 = params[:ubicacion][:anno53].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 104
      dato2 = params[:ubicacion][:anno104].to_s rescue nil
      if dato2.to_s != ""
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: dato2.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end  
    elsif idReport == 105
      dato2 = params[:ubicacion][:anno105].to_s rescue nil
      if dato2.to_s != ""
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: dato2.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end  
    elsif idReport == 55
      dato1 = params[:ubicacion][:mes55].to_s rescue nil
      dato2 = params[:ubicacion][:anno55].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 56 or idReport == 57
      dato1 = params[:ubicacion][:eproveedorid].to_s rescue nil
      dato2 = params[:ubicacion][:eproveedorid57].to_s rescue nil
      if dato1.to_s != ""
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: dato1.to_s, format: :xlsx)
      elsif dato2.to_s != ""
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: dato2.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 58
      dato1 = params[:ubicacion][:contratoid58].to_s rescue nil
      if dato1.to_s != ""
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: dato1.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 27
      idContrato = params[:ubicacion][:contratoid_27].to_s rescue nil
      if idContrato.to_s != ""
        varid = idContrato.to_s
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 59
      dato1 = params[:ubicacion][:mes59].to_s rescue nil
      dato2 = params[:ubicacion][:anno59].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 60
      dato1 = params[:ubicacion][:mes60].to_s rescue nil
      dato2 = params[:ubicacion][:anno60].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 61
      dato1 = params[:ubicacion][:mes61].to_s rescue nil
      dato2 = params[:ubicacion][:anno61].to_s rescue nil
      dato3 = params[:ubicacion][:sede61].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != "" and dato3.to_s != ""
        varid = dato2 + '-' + dato1 + '-' + dato3
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 63
      dato1 = params[:ubicacion][:mes47].to_s rescue nil
      dato2 = params[:ubicacion][:anno47].to_s rescue nil
      dato3 = params[:ubicacion][:contratoid].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != "" and dato3.to_s != ""
        varid = dato2 + '-' + dato1 + '-' + dato3
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 66
      dato1 = params[:ubicacion][:anno66].to_s rescue nil
      dato2 = params[:ubicacion][:proceso66].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != ""
        varid = dato2 + '-' + dato1
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 74
      ActiveRecord::Base.connection.execute("CALL prc_informeespecial_a;")
      redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
    elsif idReport == 75
      idContrato = params[:ubicacion][:contratoid75].to_s rescue nil
      dato1 = params[:ubicacion][:mes75].to_s rescue nil
      dato2 = params[:ubicacion][:anno75].to_s rescue nil
      if dato1.to_s != "" and dato2.to_s != "" and idContrato.to_s != ""
        ActiveRecord::Base.connection.execute("CALL prc_informeespecial_laboro(#{idContrato},#{dato2},'#{dato1}');")
        redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 76
      idTipoFormato = params[:ubicacion][:formato76].to_s rescue nil
      @dato1 = params[:ubicacion][:mes76].to_s rescue nil
      @dato2 = params[:ubicacion][:anno76].to_s rescue nil
      if @dato1.to_s != "" and @dato2.to_s != "" and idTipoFormato.to_s != ""
        if idTipoFormato == 'EXCEL'
          varid = @dato2 + '-' + @dato1
          ActiveRecord::Base.connection.execute("CALL prc_informe_76(#{@dato2},'#{@dato1}');")
          redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
        elsif idTipoFormato == 'PDF'
          redirect_to informe_pdf_datas_path(infgrupo_id: idReport, anno: @dato2, mes: @dato1, format: :pdf)
        end
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 84
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
    elsif idReport == 85
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: params[:tarea_id], format: :xlsx)
    elsif idReport == 90
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: params[:evaluacion_id], format: :xlsx)
    elsif idReport == 91
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: params[:fchinicial], format: :xlsx)
    elsif idReport == 102
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: nil, format: :xlsx)
    elsif idReport == 77
      idTipoFormato = params[:ubicacion][:formato77].to_s rescue nil
      @dato1 = params[:ubicacion][:mes77].to_s rescue nil
      @dato2 = params[:ubicacion][:anno77].to_s rescue nil
      @dato3 = params[:ubicacion][:contratoid77].to_s rescue nil
      if @dato1.to_s != "" and @dato2.to_s != "" and @dato3.to_s != "" and idTipoFormato.to_s != ""
        varid = @dato2 + '-' + @dato1
        ActiveRecord::Base.connection.execute("CALL prc_informe_77(#{@dato2},'#{@dato1}',#{@dato3});")
        if idTipoFormato == 'EXCEL'
          redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: varid.to_s, format: :xlsx)
        elsif idTipoFormato == 'PDF'
          redirect_to informe_pdf_examenes_datas_path(infgrupo_id: idReport, anno: @dato2, mes: @dato1, contrato_id: @dato3, format: :pdf)
        end
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 92
      flash[:notice] = "Generado con Exito!!!"
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: params[:contratoscapacitacion_id], format: :xlsx)
    elsif idReport == 79
      ActiveRecord::Base.connection.execute("CALL prc_informe_79(#{idContrato})")
      redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
    elsif idReport == 94
      ActiveRecord::Base.connection.execute("CALL prc_informe_94('#{idContrato.to_s}')")
      redirect_to informe_datas_path(infgrupo_id: idReport, format: :xlsx)
    elsif idReport == 95
      idTipoFormato = params[:ubicacion][:formato95].to_s rescue nil

      @dato1 = params[:fchinicio95].to_s rescue nil
      @dato2 = params[:fchfinal95].to_s rescue nil
      if @dato1.to_s != "" and @dato2.to_s != "" and idTipoFormato.to_s != ""
        ActiveRecord::Base.connection.execute("CALL prc_informe_95('#{@dato1}','#{@dato2}',#{is_admin});")
        if idTipoFormato == 'EXCEL'
          redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: is_admin, format: :xlsx)
        elsif idTipoFormato == 'PDF'
          redirect_to informe_pdf_inventarios_datas_path(infgrupo_id: idReport, fchinicio: @dato1, fchfinal: @dato2, format: :pdf)
        end
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 101
      idTipoFormato = params[:ubicacion][:formato101].to_s rescue nil

      @dato1 = params[:fchinicio101].to_s rescue nil
      @dato2 = params[:fchfinal101].to_s rescue nil
      if @dato1.to_s != "" and @dato2.to_s != ""
        ActiveRecord::Base.connection.execute("CALL prc_informe_101('#{@dato1}','#{@dato2}',#{is_admin});")
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: is_admin, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 110
      @dato1 = params[:fchinicio110].to_s rescue nil
      @dato2 = params[:fchfinal110].to_s rescue nil
      if @dato1.to_s != "" and @dato2.to_s != ""
        ActiveRecord::Base.connection.execute("CALL prc_informe_110('#{@dato1}','#{@dato2}',#{is_admin});")
        redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: is_admin, format: :xlsx)
      else
        flash[:notice] = "Debe ingresar los datos completos"
        redirect_to reportes_path
      end
    elsif idReport == 111
      ActiveRecord::Base.connection.execute("CALL prc_informe_111;")
      redirect_to informe_datas_path(infgrupo_id: idReport, portafolio_id: is_admin, format: :xlsx)
    end
  end

  def informe_pdf
    @anno = params[:anno]
    @mes = params[:mes]
    @contratosperactobs = Contratosperactob.select("contratospersona_id").where("anno = '#{@anno}' and mes = '#{@mes}'").distinct
    respond_to do |format|
      format.pdf { render pdf: "Evaluación #{@anno}-#{@mes}", template: "contratospersonas/evaluacion_reporte_pdf.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def informe_pdf_examenes
    @anno = params[:anno]
    @mes = params[:mes]
    @contrato_id = params[:contrato_id]
    ActiveRecord::Base.connection.execute("UPDATE personasforencuestas SET calificacion = (SELECT clase FROM encuestapreopciones WHERE id = personasforencuestas.encuestapreopcion_id)
                                            WHERE personasformulario_id > 0
                                            AND   calificacion IS NULL")
    @personasforencuestas = Personasforencuesta.joins(:personasformulario)
                                               .select("distinct personasforencuestas.personasformulario_id")
                                               .where("personasformularios.id in (select personasformulario_id from informe_77 where contrato_id = #{@contrato_id})").distinct
    respond_to do |format|
      format.pdf { render pdf: "Examenes #{@anno}-#{@mes}", template: "personasforencuestas/examen_reporte_pdf.html.erb", encoding: "UTF-8", disposition: 'attachment',
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def informe_pdf_inventarios
    @dato1 = params[:fchinicio].to_s rescue nil
    @dato2 = params[:fchfinal].to_s rescue nil
    @contratosperinventarios = Contratosperinventario.where("DATE_FORMAT(created_at, '%Y-%m-%d') BETWEEN ? AND ?", @dato1, @dato2)
    respond_to do |format|
      format.pdf { render pdf: "Inventarios", template: "contratosperinventarios/visualizar_masivo", encoding: "UTF-8", disposition: 'attachment',
                          page_size: 'Letter', :margin => { top: 10, :bottom => 10, :left => 15, :right => 15 } }
    end
  end

  def informe
    # ActiveRecord::Base.connection.execute("CALL validacion")
    portafolioId = params[:portafolio_id]
    idReport = params[:infgrupo_id]
    infgrupo = Infgrupo.find(idReport)
    tablas = Infgrupostabla.where(infgrupo_id: infgrupo.id).order(:orden)
    if tablas.count.to_i > 0
      p = Axlsx::Package.new
      p.use_autowidth = false
      wd = p.workbook
      wd.styles do |style|
        title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header = wd.styles.add_style(b: true, bg_color: "FFdd4b39", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header1 = wd.styles.add_style(b: true, bg_color: "FFff851b", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header2 = wd.styles.add_style(b: true, bg_color: "FF00a65a", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header3 = wd.styles.add_style(b: true, bg_color: "FF417932", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header4 = wd.styles.add_style(b: true, bg_color: "FFE16E28", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosiz = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :left, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datoscent = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosder = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        fecha = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy', :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosnumeros = wd.styles.add_style(:format_code => '#,###,###0.#0', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosnumeros2 = wd.styles.add_style(:format_code => '#,###,###0', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        porcentaje = wd.styles.add_style(:num_fmt => Axlsx::NUM_FMT_PERCENT, sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        observacion = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :left, :wrap_text => true, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        fecha_min = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy HH:MM:SS', :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        tablas.each do |t|

          tablasCampos = Infgrupostablascampo.where(infgrupostabla_id: t.id).order("orden")
          if t.plano.to_s == 'PARAMETRO'
            tbDatos = Objeto.find_by_sql(["#{t.consulta.to_s}", portafolioId])
          else
            tbDatos = Objeto.find_by_sql(["#{t.consulta.to_s}"])
          end

          if tbDatos.present?
            encabHoja = []
            encabStyle = []
            styleHoja = []
            typesHoja = []
            tamano = []

            campo = tablasCampos.map(&:campo).join(',').split(',')
            encabHoja = tablasCampos.map(&:encabezado).join('|').split('|')

            tablasCampos.each do |p|
              encabStyle.push eval(p.encabezado_estilo)
              styleHoja.push eval(p.estilo)
              typesHoja.push eval(p.tipo)
              tamano.push p.tamano
            end

            wd.add_worksheet(:name => t.hoja.to_s) do |sheet|
              sheet.add_row encabHoja, style: encabStyle

              tbDatos.each do |dat|
                datosHoja = JSON.parse(dat.to_json(only: [campo], :methods => campo))
                sheet.add_row datosHoja.values, style: styleHoja, types: typesHoja, :widths => tamano
              end

            end
          else
            wd.add_worksheet(:name => t.hoja.to_s) do |sheet|
              sheet.add_row ['NO hay informacion']
            end
          end
        end
        # 2020-08-02 FFA: Para generar estandar de cargue de una vez....
        if ['13', '14', '16', '17'].include?(infgrupo.id)
          nombrearchivo = 'migracionesinsumos'
          migracion = Migracion.where(["nombre_resultado = '#{nombrearchivo.to_s}'"]).first
          headers = []
          tamano = []
          migracion.migracionescampos.order("orden asc").each do |m|
            headers << m.encabezado
            tamano.push 20
          end
          wd.add_worksheet(:name => 'ESTRUCTURA CARGUE') do |sheet|
            sheet.add_row headers, style: header2, :widths => tamano
          end
        end
      end
      rootName = "#{::Rails.root}/public/archivos/download/#{infgrupo.nombre_archivo}_#{Date.today}.xlsx"
      FileUtils.rm_r Dir.glob("#{rootName}")
      p.serialize("#{rootName}")
    end
    send_file rootName.to_s, :disposition => "attachment"
  end

  def informe_rowspan
    portafolioId = params[:portafolio_id]
    mes = params[:mes]
    userid = params[:userid].to_i
    nombreuser = User.find(userid).nombre.gsub(' ','_')
    ActiveRecord::Base.connection.execute("CALL prc_informe_94_esp('#{mes.to_s}',#{userid})")
    idReport = params[:infgrupo_id]
    infgrupo = Infgrupo.find(idReport)
    tablas = Infgrupostabla.where(infgrupo_id: infgrupo.id).order(:orden)
    if tablas.count.to_i > 0
      p = Axlsx::Package.new
      p.use_autowidth = false
      wd = p.workbook
      wd.styles do |style|
        title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header = wd.styles.add_style(b: true, bg_color: "FFdd4b39", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header1 = wd.styles.add_style(b: true, bg_color: "FFff851b", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header2 = wd.styles.add_style(b: true, bg_color: "FF00a65a", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header3 = wd.styles.add_style(b: true, bg_color: "FF417932", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        header4 = wd.styles.add_style(b: true, bg_color: "FFE16E28", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosiz = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :left, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datoscent = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosder = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        fecha = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy', :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosnumeros = wd.styles.add_style(:format_code => '#,###,###0.#0', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        datosnumeros2 = wd.styles.add_style(:format_code => '#,###,###0', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        porcentaje = wd.styles.add_style(:num_fmt => Axlsx::NUM_FMT_PERCENT, sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        observacion = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :left, :wrap_text => true, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        fecha_min = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy HH:MM:SS', :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
        tablas.each do |t|

          tablasCampos = Infgrupostablascampo.where(infgrupostabla_id: t.id).order("orden")
          if t.plano.to_s == 'PARAMETRO'
            tbDatos = Objeto.find_by_sql(["#{t.consulta.to_s}", portafolioId])
          else
            tbDatos = Objeto.find_by_sql(["#{t.consulta.to_s}"])
          end

          if tbDatos.present?
            encabHoja = []
            encabStyle = []
            styleHoja = []
            typesHoja = []
            tamano = []

            campo = tablasCampos.map(&:campo).join(',').split(',')
            encabHoja = tablasCampos.map(&:encabezado).join('|').split('|')

            tablasCampos.each do |p|
              encabStyle.push eval(p.encabezado_estilo)
              styleHoja.push eval(p.estilo)
              typesHoja.push eval(p.tipo)
              tamano.push p.tamano
            end

            wd.add_worksheet(:name => t.hoja.to_s) do |sheet|
              sheet.add_row encabHoja, style: encabStyle
              cantcol = 11
              psi = 1
              semana1 = ""
              semana2 = ""
              semana3 = ""
              semana4 = ""
              semana5 = ""
              semanaf = ""
              tbDatos.each do |dat|
                datosHoja = JSON.parse(dat.to_json(only: [campo], :methods => campo))
                sheet.add_row datosHoja.values, style: styleHoja, types: typesHoja, :widths => tamano
                if dat.sem1.to_i > 0 and semana1 == ""
                    psf = psi + dat.sem1.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol, psi) + ':' + Axlsx::cell_r(cantcol, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+2, psi) + ':' + Axlsx::cell_r(cantcol+2, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+3, psi) + ':' + Axlsx::cell_r(cantcol+3, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+4, psi) + ':' + Axlsx::cell_r(cantcol+4, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+5, psi) + ':' + Axlsx::cell_r(cantcol+5, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+6, psi) + ':' + Axlsx::cell_r(cantcol+6, psf)
                    semana1 = 'C'
                    psi = psf + 1
                elsif dat.sem2.to_i > 0 and semana2 == ""
                    psf = psi + dat.sem2.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol, psi) + ':' + Axlsx::cell_r(cantcol, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+2, psi) + ':' + Axlsx::cell_r(cantcol+2, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+3, psi) + ':' + Axlsx::cell_r(cantcol+3, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+4, psi) + ':' + Axlsx::cell_r(cantcol+4, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+5, psi) + ':' + Axlsx::cell_r(cantcol+5, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+6, psi) + ':' + Axlsx::cell_r(cantcol+6, psf)
                    semana2 = 'C'
                    psi = psf + 1
                elsif dat.sem3.to_i > 0 and semana3 == ""
                    psf = psi + dat.sem3.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol, psi) + ':' + Axlsx::cell_r(cantcol, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+2, psi) + ':' + Axlsx::cell_r(cantcol+2, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+3, psi) + ':' + Axlsx::cell_r(cantcol+3, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+4, psi) + ':' + Axlsx::cell_r(cantcol+4, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+5, psi) + ':' + Axlsx::cell_r(cantcol+5, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+6, psi) + ':' + Axlsx::cell_r(cantcol+6, psf)
                    semana3 = 'C'
                    psi = psf + 1
                elsif dat.sem4.to_i > 0 and semana4 == ""
                    psf = psi + dat.sem4.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol, psi) + ':' + Axlsx::cell_r(cantcol, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+2, psi) + ':' + Axlsx::cell_r(cantcol+2, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+3, psi) + ':' + Axlsx::cell_r(cantcol+3, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+4, psi) + ':' + Axlsx::cell_r(cantcol+4, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+5, psi) + ':' + Axlsx::cell_r(cantcol+5, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+6, psi) + ':' + Axlsx::cell_r(cantcol+6, psf)
                    semana4 = 'C'
                    psi = psf + 1
                elsif dat.sem5.to_i > 0 and semana5 == ""
                    psf = psi + dat.sem5.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol, psi) + ':' + Axlsx::cell_r(cantcol, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+2, psi) + ':' + Axlsx::cell_r(cantcol+2, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+3, psi) + ':' + Axlsx::cell_r(cantcol+3, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+4, psi) + ':' + Axlsx::cell_r(cantcol+4, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+5, psi) + ':' + Axlsx::cell_r(cantcol+5, psf)
                    sheet.merge_cells Axlsx::cell_r(cantcol+6, psi) + ':' + Axlsx::cell_r(cantcol+6, psf)
                    semana5 = 'C'
                    psi = psf
                end
                if dat.tiempototal.to_i > 0 and semanaf == ""
                    psf = 1 + dat.totalvisias.to_i - 1
                    sheet.merge_cells Axlsx::cell_r(cantcol+1, 1) + ':' + Axlsx::cell_r(cantcol+1, psf)
                    semanaf = 'C'
                end
              end
            end
          else
            wd.add_worksheet(:name => t.hoja.to_s) do |sheet|
              sheet.add_row ['NO hay informacion']
            end
          end
        end
      end
      rootName = "#{::Rails.root}/public/archivos/download/#{infgrupo.nombre_archivo}_#{nombreuser}_Periodo_#{mes}.xlsx"
      FileUtils.rm_r Dir.glob("#{rootName}")
      p.serialize("#{rootName}")
    end
    send_file rootName.to_s, :disposition => "attachment"
  end

  def headxls
    nombrearchivo = params[:nombrearchivo].to_s
    id = params[:id].to_s
    if nombrearchivo.to_s != ""
      migracion = Migracion.where(["nombre_resultado = '#{nombrearchivo.to_s}'"]).first
    elsif id.to_s != ""
      migracion = Migracion.where(["id = '#{id.to_s}'"]).first
    end
    headers = []
    tamano = []
    migracion.migracionescampos.order("orden asc").each do |m|
      headers << m.encabezado
      tamano.push 20
    end

    p = Axlsx::Package.new
    p.use_autowidth = false
    wd = p.workbook
    wd.styles do |style|
      title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)

      wd.add_worksheet(:name => migracion.nombre.to_s) do |sheet|
        sheet.add_row headers, style: title, :widths => tamano
      end
    end
    rootName = "#{::Rails.root}/public/archivos/download/#{migracion.nombre}_#{Date.today}.xlsx"
    FileUtils.rm_r Dir.glob("#{rootName}")
    p.serialize("#{rootName}")

    send_file rootName.to_s, :disposition => "attachment"
  end

  def codigos
    p = Axlsx::Package.new
    wd = p.workbook
    wd.styles do |style|
      title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)

      wd.add_worksheet(:name => "Cargos") do |sheet|
        sheet.add_row ["Id", "Cargos"], style: title
        Parcargo.where("estado = 'ACTIVO'").order("id asc").each do |parcargo|
          sheet.add_row [parcargo.id, parcargo.descripcion]
        end
      end

      wd.add_worksheet(:name => "Municipios") do |sheet|
        sheet.add_row ["Id", "Municipio", "Region"], style: title
        Municipio.order("autobuscar asc").each do |municipio|
          sheet.add_row [municipio.id, municipio.autobuscar, municipio.region]
        end
      end

      wd.add_worksheet(:name => "Secciones") do |sheet|
        sheet.add_row ["Nombre Empresa", "Nro Contrato", "Grupo de Nomina", "Cargo", "IDMunicipio", "Municipio", "IdSeccion", "Colegio", "Cantidad"], style: title
        Parcargo.find_by_sql("SELECT e.autobuscar nombre_empresa, c.nro_contrato, g.descripcion grupo_nomina, cc.perfil cargo,
                                m.id idmunicipio, m.autobuscar municipio, s.id idseccion, s.descripcion colegio, s.cantidad
                              FROM   contratossecciones s, contratos c, empresas e, contratosgrupos g, contratoscargos cc, municipios m
                              WHERE  s.contrato_id = c.id
                              AND    c.empresa_id = e.id
                              AND    s.municipio_id = m.id
                              AND    s.contratosgrupo_id = g.id
                              AND    s.contratoscargo_id = cc.id").each do |dato|
          sheet.add_row [dato.nombre_empresa, dato.nro_contrato, dato.grupo_nomina, dato.cargo, dato.idmunicipio, dato.municipio, dato.idseccion, dato.colegio, dato.cantidad]
        end
      end

    end
    rootName = "#{::Rails.root}/public/archivos/download/Codigos_Cargue_#{Date.today}.xlsx"
    FileUtils.rm_r Dir.glob("#{rootName}")
    p.serialize("#{rootName}")

    send_file rootName.to_s, :disposition => "attachment"
  end

  def generar_lote
    lote = params[:lote]
    p = Axlsx::Package.new
    wd = p.workbook
    wd.styles do |style|
      title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)

      wd.add_worksheet(:name => "Lote #{lote}") do |sheet|
        if lote.to_i > 0
          datos = Personasformulario.find_by_sql("SELECT a.*
                                          FROM  (SELECT p.id,p.identificacion,
                                                   CONCAT(IFNULL(p.nombre,''),' ',IFNULL(p.primer_apellido,''),' ',IFNULL(p.segundo_apellido,'')) nombre,
                                                   m.`descripcion`,
                                                   m.`region`,p.colegio,
                                                   NULL desc_examen,
                                                   NULL direccion,
                                                   NULL fecha,
                                                   NULL recomendaciones,
                                                   NULL hora,p.archivo_id,(SELECT descripcion FROM parcargos WHERE id = p.parcargo_id) cargo,
                                                   (select nombre from users where id = p.user_asignado) supervisor,
                                                   null estado
                                            FROM   personasformularios p, municipios m
                                            WHERE  p.municipio_id = m.`id`
                                            AND    p.id NOT IN (SELECT personasformulario_id FROM personasformulariosexamenes f WHERE f.`personasformulario_id` = p.id)
                                            UNION
                                            SELECT p.id, p.identificacion,
                                                   CONCAT(IFNULL(p.nombre,''),' ',IFNULL(p.primer_apellido,''),' ',IFNULL(p.segundo_apellido,'')) nombre,
                                                   m.`descripcion`,
                                                   m.`region`, p.colegio,
                                                   e.descripcion desc_examen,
                                                   e.direccion,
                                                   e.fecha,
                                                   e.`recomendaciones`,
                                                   e.hora,p.archivo_id,(SELECT descripcion FROM parcargos WHERE id = p.parcargo_id) cargo,
                                                   (select nombre from users where id = p.user_asignado) supervisor,
                                                   e.estado
                                            FROM   personasformularios p, municipios m, personasformulariosexamenes e
                                            WHERE  p.municipio_id = m.`id`
                                            AND    e.id = (SELECT MAX(f.id) FROM personasformulariosexamenes f WHERE f.`personasformulario_id` = p.id)) a
                                          WHERE a.archivo_id = #{lote}
                                          ORDER BY a.descripcion")
        elsif lote.to_i == -1 # Todos
          datos = Personasformulario.find_by_sql("SELECT a.*
                                          FROM  (SELECT p.id,p.identificacion,
                                                   CONCAT(IFNULL(p.nombre,''),' ',IFNULL(p.primer_apellido,''),' ',IFNULL(p.segundo_apellido,'')) nombre,
                                                   m.`descripcion`,
                                                   m.`region`,p.colegio,
                                                   NULL desc_examen,
                                                   NULL direccion,
                                                   NULL fecha,
                                                   NULL recomendaciones,
                                                   NULL hora,p.archivo_id,(SELECT descripcion FROM parcargos WHERE id = p.parcargo_id) cargo,
                                                   (select nombre from users where id = p.user_asignado) supervisor,
                                                   null estado
                                            FROM   personasformularios p, municipios m
                                            WHERE  p.municipio_id = m.`id`
                                            AND    p.id NOT IN (SELECT personasformulario_id FROM personasformulariosexamenes f WHERE f.`personasformulario_id` = p.id)
                                            UNION
                                            SELECT p.id, p.identificacion,
                                                   CONCAT(IFNULL(p.nombre,''),' ',IFNULL(p.primer_apellido,''),' ',IFNULL(p.segundo_apellido,'')) nombre,
                                                   m.`descripcion`,
                                                   m.`region`, p.colegio,
                                                   e.descripcion desc_examen,
                                                   e.direccion,
                                                   e.fecha,
                                                   e.`recomendaciones`,
                                                   e.hora,p.archivo_id,(SELECT descripcion FROM parcargos WHERE id = p.parcargo_id) cargo,
                                                   (select nombre from users where id = p.user_asignado) supervisor,
                                                   e.estado
                                            FROM   personasformularios p, municipios m, personasformulariosexamenes e
                                            WHERE  p.municipio_id = m.`id`
                                            AND    e.id = (SELECT MAX(f.id) FROM personasformulariosexamenes f WHERE f.`personasformulario_id` = p.id)) a
                                          ORDER BY a.descripcion")
        elsif lote.to_i == -2 # Pendientes
          datos = Personasformulario.find_by_sql("SELECT a.*
                                          FROM  (SELECT p.id,p.identificacion,
                                                   CONCAT(IFNULL(p.nombre,''),' ',IFNULL(p.primer_apellido,''),' ',IFNULL(p.segundo_apellido,'')) nombre,
                                                   m.`descripcion`,
                                                   m.`region`,p.colegio,
                                                   NULL desc_examen,
                                                   NULL direccion,
                                                   NULL fecha,
                                                   NULL recomendaciones,
                                                   NULL hora,p.archivo_id,(SELECT descripcion FROM parcargos WHERE id = p.parcargo_id) cargo,
                                                   (select nombre from users where id = p.user_asignado) supervisor,
                                                   p.estado estado
                                            FROM   personasformularios p, municipios m
                                            WHERE  p.municipio_id = m.`id`
                                            AND    not exists (SELECT 1 FROM personasformulariosexamenes f WHERE f.`personasformulario_id` = p.id)) a
                                          ORDER BY a.descripcion")
        end
        sheet.add_row ["Id Candidato", "Identificacion", "Nombre Completo", "Descripcion Examen Requerido", "Direccion Sitio", "Recomendaciones", "Fecha", "Hora", "Estado", "Municipio", "Zona", "Colegio", "Cargo", "Supervisor"], style: title
        datos.each do |p|
          sheet.add_row [p.id, p.identificacion, p.nombre, p.desc_examen, p.direccion, p.recomendaciones, p.fecha, p.hora, p.estado, p.descripcion, p.region, p.colegio, p.cargo, p.supervisor]
        end
      end
    end
    rootName = "#{::Rails.root}/public/archivos/download/Lote_Cargue_#{Date.today}.xlsx"
    FileUtils.rm_r Dir.glob("#{rootName}")
    p.serialize("#{rootName}")

    send_file rootName.to_s, :disposition => "attachment"
  end

  def generar_lote_estado
    lote = params[:lote]
    p = Axlsx::Package.new
    wd = p.workbook
    wd.styles do |style|
      title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)

      wd.add_worksheet(:name => "Lote #{lote}") do |sheet|
        sheet.add_row ["Id Candidato", "Identificacion", "Nombre Completo", "Estado", "Observacion EPS"], style: title
        Personasformulario.where("archivo_id = #{lote}").order("id asc").each do |personasformulario|
          examen = personasformulario.personasformulariosexamenes.last rescue nil
          estado = examen.estado rescue nil
          sheet.add_row [personasformulario.id, personasformulario.identificacion, personasformulario.nombre_completo, estado, ""]
        end
      end
    end
    rootName = "#{::Rails.root}/public/archivos/download/Lote_Estado_Cargue_#{Date.today}.xlsx"
    FileUtils.rm_r Dir.glob("#{rootName}")
    p.serialize("#{rootName}")

    send_file rootName.to_s, :disposition => "attachment"
  end

  def descargardocbyperfechasalud
    contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    contratosperfechasdoc = contratosperfecha.contratosperfechasdocs rescue nil
    folder = "public/system/soporte_digitales/"
    dfolder = "public/system/personasimagenes/"
    bfolder = "public/system/soporte_digitales/"
    folderform = "public/download/"
    nombreform = ""
    binput_filenames = []
    binput_fileids = []
    binput_fileperiodo = []
    if contratosperfechasdoc.present?
      b = 0
      contratosperfechasdoc.each do |d|
        binput_filenames[b] = d.soporte_digital_file_name.to_s
        binput_fileids[b] = d.id.to_s
        binput_fileperiodo[b] = 'AFILIACION_' + d.tipo.to_s.upcase
        b = b + 1
      end
      fname = 'DOCASEAR_SALUD_' + contratosperfecha.contratospersona.identificacion + '.zip'
      zipfile_folder = "public/download/" + fname
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        b = 0
        binput_filenames.each do |filename|
          ruta = binput_fileids[b].to_s
          bashrc = File.join(bfolder + ruta + '/original', filename)
          if File.exist?(bashrc) # => true
            zipfile.add(binput_fileperiodo[b].to_s + '_(' + binput_fileids[b] + ')_' + filename, File.join(bfolder + ruta + '/original', filename))
          end
          b = b + 1
        end
      end
    end
    zip_data = File.read(zipfile_folder)
    send_data(zip_data, :type => 'application/zip', :filename => fname)
    File.delete(zipfile_folder) if File.exist?(zipfile_folder)
  end

  def descargardocbyperfecha
    contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    if contratosperfecha.personasformulario_id.to_s == ""
      idForm = -1
    else
      idForm = contratosperfecha.personasformulario_id rescue nil
    end
    documentospre = Personasformulariosdoc.where("estado = 'APROBADO' and personasformulario_id = #{idForm}") rescue nil
    contratosdoc = Contratosperimagen.where("contratosperfecha_id = #{contratosperfecha.id}") rescue nil

    contratosdochv = Contratosperimagen.where("contratospersona_id = #{contratosperfecha.contratospersona_id} and user_id = 1 and descripcion = 'HOJA DE VIDA' and contratosperfecha_id is null").first rescue nil
    if contratosdochv.present?
      contratosdochv.destroy
    end
    ContratospersonasController.hojavida_att(contratosperfecha.contratospersona_id)
    contratosdochv = Contratosperimagen.where("contratospersona_id = #{contratosperfecha.contratospersona_id} and user_id = 1 and descripcion = 'HOJA DE VIDA' and contratosperfecha_id is null") rescue nil

    contratosperfechasdoc = contratosperfecha.contratosperfechasdocs rescue nil
    folder = "public/system/soporte_digitales/"
    dfolder = "public/system/personasimagenes/"
    bfolder = "public/system/soporte_digitales/"
    folderform = "public/download/"
    nombreform = ""
    input_filenames = []
    input_fileids = []
    input_fileperiodo = []
    dinput_filenames = []
    dinput_fileids = []
    dinput_fileperiodo = []
    binput_filenames = []
    binput_fileids = []
    binput_fileperiodo = []
    if documentospre.present? or contratosdoc.present? or contratosperfechasdoc.present?
      i = 0
      documentospre.each do |d|
        input_filenames[i] = d.soporte_digital_file_name.to_s
        input_fileids[i] = d.id.to_s
        input_fileperiodo[i] = d.parcargosdoc.descripcion.to_s.upcase rescue 'NN'
        i = i + 1
      end
      a = 0
      contratosdoc.each do |d|
        dinput_filenames[a] = d.personasimagen_file_name.to_s
        dinput_fileids[a] = d.id.to_s
        dinput_fileperiodo[a] = d.descripcion.to_s.upcase rescue 'NN'
        a = a + 1
      end
      # Se adiciona la HV
      contratosdochv.each do |d|
        dinput_filenames[a] = d.personasimagen_file_name.to_s
        dinput_fileids[a] = d.id.to_s
        dinput_fileperiodo[a] = d.descripcion.to_s.upcase rescue 'NN'
        a = a + 1
      end
      b = 0
      contratosperfechasdoc.each do |d|
        binput_filenames[b] = d.soporte_digital_file_name.to_s
        binput_fileids[b] = d.id.to_s
        binput_fileperiodo[b] = 'AFILIACION_' + d.tipo.to_s.upcase rescue 'NN'
        b = b + 1
      end
      fname = 'DOCASEAR_' + contratosperfecha.contratospersona.identificacion + '.zip'
      zipfile_folder = "public/download/" + fname
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        i = 0
        if input_filenames.present?
          input_filenames.each do |filename|
            ruta = input_fileids[i].to_s
            bashrc = File.join(folder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(input_fileperiodo[i].to_s + '_(' + input_fileids[i] + ')_' + filename, File.join(folder + ruta + '/original', filename))
            end
            i = i + 1
          end
        end
        a = 0
        if dinput_filenames.present?
          dinput_filenames.each do |filename|
            ruta = dinput_fileids[a].to_s
            bashrc = File.join(dfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
            end
            a = a + 1
          end
        end
        b = 0
        if binput_filenames.present?
          binput_filenames.each do |filename|
            ruta = binput_fileids[b].to_s
            bashrc = File.join(bfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(binput_fileperiodo[b].to_s + '_(' + binput_fileids[b] + ')_' + filename, File.join(bfolder + ruta + '/original', filename))
            end
            b = b + 1
          end
        end
      end
    end
    if zipfile_folder.present?
      zip_data = File.read(zipfile_folder)
      send_data(zip_data, :type => 'application/zip', :filename => fname)
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
    else
      flash[:notice] = "Documentos no encontrados!!!"
      redirect_to edit_contratospersona_path(id: contratosperfecha.contratospersona_id, etapa: 'F')
    end
  end

  def self.notificacionvacante(idPersonaVacante)
    detalle = Objeto.find_by_sql("SELECT CONCAT('Cliente: ',IFNULL(e.autobuscar,''),' - NroContrato: ',c.nro_contrato,' - Cargo: ', cc.perfil) detallecargo
                                  FROM   contratoscargospersonas cp, contratoscargos cc, contratos c, empresas e
                                  WHERE  cp.id = #{idPersonaVacante}
                                  AND    cp.contratoscargo_id = cc.id
                                  AND    cc.contrato_id = c.id
                                  AND    c.empresa_id = e.id")[0].detallecargo.to_s rescue nil
    mensaje = "ASEAR: Vacante nueva: #{detalle}"
    Userspermiso.where("objeto_id = 127").each do |a|
      Asearsms::SendsmsServices.new.send_sms_users(a.user_id, mensaje)
    end
  end

  def self.descargardocbycontrato(idContrato, idUserId, vcFch)
    if vcFch.to_s == '-1'
      contratosperfechas = Contratosperfecha.where(contrato_id: idContrato)
      fname1 = 'DOCASEAR_Full_' + idContrato.to_s + '_*'
    else
      contratosperfechas = Contratosperfecha.where("contrato_id = #{idContrato} and date_format(fecha_inicio,'%Y-%m') = '#{vcFch}'")
      fname1 = 'DOCASEAR_Full_' + vcFch + '_' + idContrato.to_s + '_*'
    end
    rutaFile = "#{::Rails.root}/public/download/" + fname1.to_s
    system("rm -r #{rutaFile}")
    arrayCom = []
    contadorCom = 0
    contratosperfechas.each do |contratosperfecha|
      contadorCom = contadorCom + 1
      if contratosperfecha.personasformulario_id.to_s == ""
        idForm = -1
      else
        idForm = contratosperfecha.personasformulario_id.to_s
      end
      documentospre = Personasformulariosdoc.where("estado = 'APROBADO' and personasformulario_id = #{idForm}") rescue nil
      contratosdoc = Contratosperimagen.where("contratosperfecha_id = #{contratosperfecha.id}") rescue nil

      contratosdochv = Contratosperimagen.where("contratospersona_id = #{contratosperfecha.contratospersona_id} and user_id = 1 and descripcion = 'HOJA DE VIDA' and contratosperfecha_id is null").first rescue nil
      if contratosdochv.present?
        contratosdochv.destroy
      end
      ContratospersonasController.hojavida_att(contratosperfecha.contratospersona_id)
      contratosdochv = Contratosperimagen.where("contratospersona_id = #{contratosperfecha.contratospersona_id} and user_id = 1 and descripcion = 'HOJA DE VIDA' and contratosperfecha_id is null") rescue nil

      contratosperfechasdoc = contratosperfecha.contratosperfechasdocs rescue nil
      folder = "public/system/soporte_digitales/"
      dfolder = "public/system/personasimagenes/"
      bfolder = "public/system/soporte_digitales/"
      folderform = "public/download/"
      nombreform = ""
      input_filenames = []
      input_fileids = []
      input_fileperiodo = []
      dinput_filenames = []
      dinput_fileids = []
      dinput_fileperiodo = []
      binput_filenames = []
      binput_fileids = []
      binput_fileperiodo = []
      if documentospre.present? or contratosdoc.present? or contratosperfechasdoc.present?
        i = 0
        documentospre.each do |d|
          input_filenames[i] = d.soporte_digital_file_name.to_s
          input_fileids[i] = d.id.to_s
          input_fileperiodo[i] = d.parcargosdoc.descripcion.to_s.upcase rescue 'NN'
          i = i + 1
        end
        a = 0
        contratosdoc.each do |d|
          dinput_filenames[a] = d.personasimagen_file_name.to_s
          dinput_fileids[a] = d.id.to_s
          dinput_fileperiodo[a] = d.descripcion.to_s.upcase rescue 'NN'
          a = a + 1
        end
        # Se adiciona la HV
        contratosdochv.each do |d|
          dinput_filenames[a] = d.personasimagen_file_name.to_s
          dinput_fileids[a] = d.id.to_s
          dinput_fileperiodo[a] = d.descripcion.to_s.upcase rescue 'NN'
          a = a + 1
        end
        b = 0
        contratosperfechasdoc.each do |d|
          binput_filenames[b] = d.soporte_digital_file_name.to_s
          binput_fileids[b] = d.id.to_s
          binput_fileperiodo[b] = 'AFILIACION_' + d.tipo.to_s.upcase
          b = b + 1
        end
        fname = 'DOCASEAR_Full_' + contratosperfecha.contratospersona.identificacion + '.zip'
        zipfile_folder = "public/download/" + fname
        File.delete(zipfile_folder) if File.exist?(zipfile_folder)

        Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
          i = 0
          input_filenames.each do |filename|
            ruta = input_fileids[i].to_s
            bashrc = File.join(folder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(input_fileperiodo[i].to_s + '_(' + input_fileids[i] + ')_' + filename, File.join(folder + ruta + '/original', filename))
            end
            i = i + 1
          end
          a = 0
          dinput_filenames.each do |filename|
            ruta = dinput_fileids[a].to_s
            bashrc = File.join(dfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
            end
            a = a + 1
          end
          b = 0
          binput_filenames.each do |filename|
            ruta = binput_fileids[b].to_s
            bashrc = File.join(bfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(binput_fileperiodo[b].to_s + '_(' + binput_fileids[b] + ')_' + filename, File.join(bfolder + ruta + '/original', filename))
            end
            b = b + 1
          end
        end
        arrayCom << fname.to_s
      end
    end

    if arrayCom.present?
      if vcFch.to_s == '-1'
        fname1 = "DOCASEAR_Full_#{idContrato.to_s}_#{Time.now.strftime("%Y%m%d_%X").to_s}.zip"
      else
        fname1 = "DOCASEAR_Full_#{vcFch}_#{idContrato.to_s}_#{Time.now.strftime("%Y%m%d_%X").to_s}.zip"
      end
      zipfile_folder = "public/download/" + fname1
      folderzip = "public/download/"

      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        arrayCom.each do |aa|
          zipfile.add(aa, File.join(folderzip, aa))
        end
      end
      arrayCom.each do |aa|
        rutanamefile = "#{::Rails.root}/#{folderzip.to_s}/#{aa}"
        File.delete(rutanamefile) if File.exist?(rutanamefile)
      end
    end
    mensaje = "ASEAR: Proceso de generacion de informacion del contrato " + idContrato.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  def self.predownload(idC, idUserId, vcFch)
    datosearch = ""
    if vcFch.to_s == '-1'
      datosearch = "contrato_id = #{idC}"
    else
      datosearch = "contrato_id = #{idC} and date_format(fecha_inicio,'%Y-%m') = '#{vcFch}'"
    end
    fname1 = 'DOCASEAR_Contratos_' + idC.to_s + '_*'
    rutaFile = "#{::Rails.root}/public/download/" + fname1.to_s
    system("rm -r #{rutaFile}")

    dfolder = "public/system/personasimagenes/"
    folderform = "public/download/"
    nombreform = ""
    dinput_filenames = []
    dinput_fileids = []
    dinput_fileperiodo = []
    a = 0
    contratosdoc = Contratosperimagen.where("contratosperfecha_id in (select id from contratosperfechas where #{datosearch}) and descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%%'") rescue nil
    contratosdoc.each do |d|
      dinput_filenames[a] = d.personasimagen_file_name.to_s
      dinput_fileids[a] = d.id.to_s
      dinput_fileperiodo[a] = d.descripcion.to_s.upcase
      a = a + 1
    end

    fname = "DOCASEAR_Contratos_#{idC.to_s}_#{Time.now.strftime("%Y%m%d_%X").to_s}.zip"
    zipfile_folder = "public/download/" + fname
    File.delete(zipfile_folder) if File.exist?(zipfile_folder)
    Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
      a = 0
      dinput_filenames.each do |filename|
        ruta = dinput_fileids[a].to_s
        bashrc = File.join(dfolder + ruta + '/original', filename)
        if File.exist?(bashrc) # => true
          zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
        end
        a = a + 1
      end
    end
    mensaje = "ASEAR: Proceso de generacion de contratos firmados del contrato " + idC.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  def self.descargardocbycontratoafiliaciones(idContrato, idUserId, vcFch)
    if vcFch.to_s == '-1'
      contratosperfechas = Contratosperfecha.where(contrato_id: idContrato)
    else
      contratosperfechas = Contratosperfecha.where("contrato_id = #{idContrato} and date_format(fecha_inicio,'%Y-%m') = '#{vcFch}'")
    end
    fname1 = 'DOCASEAR_FullAfil_' + idContrato.to_s + '_*'
    rutaFile = "#{::Rails.root}/public/download/" + fname1.to_s
    system("rm -r #{rutaFile}")
    arrayCom = []
    contratosperfechas.each do |contratosperfecha|
      contratosperfechasdoc = contratosperfecha.contratosperfechasdocs rescue nil
      folder = "public/system/soporte_digitales/"
      dfolder = "public/system/personasimagenes/"
      bfolder = "public/system/soporte_digitales/"
      folderform = "public/download/"
      nombreform = ""
      input_filenames = []
      input_fileids = []
      input_fileperiodo = []
      dinput_filenames = []
      dinput_fileids = []
      dinput_fileperiodo = []
      binput_filenames = []
      binput_fileids = []
      binput_fileperiodo = []
      if contratosperfechasdoc.present?
        b = 0
        contratosperfechasdoc.each do |d|
          binput_filenames[b] = d.soporte_digital_file_name.to_s
          binput_fileids[b] = d.id.to_s
          binput_fileperiodo[b] = 'AFILIACION_' + d.tipo.to_s.upcase
          b = b + 1
        end
        fname = 'DOCASEAR_FullAFil_' + contratosperfecha.contratospersona.identificacion + '.zip'
        zipfile_folder = "public/download/" + fname
        File.delete(zipfile_folder) if File.exist?(zipfile_folder)
        Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
          b = 0
          binput_filenames.each do |filename|
            ruta = binput_fileids[b].to_s
            bashrc = File.join(bfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(binput_fileperiodo[b].to_s + '_(' + binput_fileids[b] + ')_' + filename, File.join(bfolder + ruta + '/original', filename))
            end
            b = b + 1
          end
        end
        arrayCom << fname.to_s
      end
    end
    # 2024-04-04 Se complementa para que se genere un solo zip con todas las afiliaciones..
    if arrayCom.present?
      fname1 = "DOCASEAR_FullAfil_#{idContrato.to_s}_#{Time.now.strftime("%Y%m%d_%X").to_s}.zip"
      zipfile_folder = "public/download/" + fname1
      folderzip = "public/download/"

      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        arrayCom.each do |aa|
          zipfile.add(aa, File.join(folderzip, aa))
        end
      end
      arrayCom.each do |aa|
        rutanamefile = "#{::Rails.root}/#{folderzip.to_s}/#{aa}"
        File.delete(rutanamefile) if File.exist?(rutanamefile)
      end
    end

    mensaje = "ASEAR: Proceso de generacion de informacion de afiliaciones del contrato " + idContrato.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  def self.descargarcartabycontrato(idContrato, idUserId)
    contratosperfechas = Contratosperfecha.where(contrato_id: idContrato)
    fname1 = 'CARTAS_Full_' + idContrato.to_s + '_*'

    rutaFile = "#{::Rails.root}/public/download/" + fname1.to_s
    system("rm -r #{rutaFile}")
    arrayCom = []
    contadorCom = 0
    contratosperfechas.each do |contratosperfecha|
      contadorCom = contadorCom + 1
      contratosdoc = Contratosperimagen.where("contratosperfecha_id = #{contratosperfecha.id} and descripcion like 'CARTA TERMINACION%'") rescue nil

      dfolder = "public/system/personasimagenes/"
      nombreform = ""
      dinput_filenames = []
      dinput_fileids = []
      dinput_fileperiodo = []
      if contratosdoc.present?
        a = 0
        contratosdoc.each do |d|
          dinput_filenames[a] = d.personasimagen_file_name.to_s
          dinput_fileids[a] = d.id.to_s
          dinput_fileperiodo[a] = d.descripcion.to_s.upcase rescue 'NN'
          a = a + 1
        end
        
        fname = 'DOCASEAR_Full_' + contratosperfecha.contratospersona.identificacion + '.zip'
        zipfile_folder = "public/download/" + fname
        File.delete(zipfile_folder) if File.exist?(zipfile_folder)

        Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
          a = 0
          dinput_filenames.each do |filename|
            ruta = dinput_fileids[a].to_s
            bashrc = File.join(dfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
            end
            a = a + 1
          end
        end
        arrayCom << fname.to_s
      end
    end

    if arrayCom.present?
      fname1 = "CARTAS_Full_#{idContrato.to_s}_#{Time.now.strftime("%Y%m%d_%X").to_s}.zip"
      zipfile_folder = "public/download/" + fname1
      folderzip = "public/download/"

      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        arrayCom.each do |aa|
          zipfile.add(aa, File.join(folderzip, aa))
        end
      end
      arrayCom.each do |aa|
        rutanamefile = "#{::Rails.root}/#{folderzip.to_s}/#{aa}"
        File.delete(rutanamefile) if File.exist?(rutanamefile)
      end
    end
    mensaje = "ASEAR: Proceso de generacion de Cartas de Terminacion del contrato " + idContrato.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end
  

  def self.ejecutacontrato(idContratosPerFecha)
    if idContratosPerFecha.to_i > 0
      ActiveRecord::Base.connection.execute("CALL prc_creausuario(#{idContratosPerFecha})")
    end
    # ActiveRecord::Base.connection.execute("call prc_personasformulariocontrato") 2023-11-25 Se desactiva porque esta dentro de creausuario
    ActiveRecord::Base.connection.execute("CALL prc_dashcontratos")
  end

  def self.refirmarcontrato(idContrato, idUserId)
    Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  f.contrato_id = #{idContrato}
                    AND    p.id = f.contratospersona_id
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
      a = Contratosperimagen.find(a.contratosperimagen_id)
      a.destroy
      ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
    end
    mensaje = "ASEAR: Proceso de RE-firma del contrato " + idContrato.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  def download
  end

  def descargarfile
    send_file params[:ruta].to_s, :disposition => "attachment"
  end

  def self.cargardigitales(idCarpeta, idUserId)
    #system("sudo chmod 777 -R /home/archivo/ftp/*.pdf")     
    rutauploadfiles = "/home/archivo/ftp/"
    namedirectory = ""
    Find.find(rutauploadfiles) do |f|
      type = case
      when File.directory?(f) then
        "D"
        puts "Encontre el Directorio... " + File.basename(f).to_s
        namedirectory = File.basename(f).to_s
        rutanew = '/home/archivo/ftp/' + namedirectory.to_s + '/'
        begin
          Find.find(rutanew) do |fi|
            type = case
              when File.file?(fi) then
                "F"
                nameFile = File.basename(fi).to_s
                puts "Encontre el Archivo.. " + nameFile.to_s
                nmIdentificacion = nameFile.split(' ')[0].to_s
                nmIdentificacion = nmIdentificacion.gsub(' ', '').to_s
                personaId = Contratospersona.where(identificacion: nmIdentificacion).first.id rescue nil
                if personaId.present?
                  begin
                    system("sudo chmod 777 '#{rutanew}#{nameFile}'")     
                    system("sudo chown deploy:deploy '#{rutanew}#{nameFile}'")                
                    puts "Archivo para cargar " + fi.to_s
                    file = File.open("#{fi.to_s}", 'rb')
                    system("sudo chown deploy:deploy /tmp/*.pdf") 
                    if file.present?
                      cpi = Contratosperimagen.new
                      cpi.contratospersona_id = personaId
                      cpi.user_id = idUserId
                      cpi.personasimagen = file
                      cpi.descripcion = 'MASIVO - ' + namedirectory.upcase
                      cpi.estado = 'APROBADO'
                      cpi.save(validate: false)
                      file.close
                      if cpi.id.to_i > 0
                        rutanamefile = "#{rutanew}#{nameFile}"
                        #File.delete(rutanamefile) if File.exist?(rutanamefile)
                        #File.delete(file)
                        logger.error("para Elimionar... el Archivo.. #{rutanew}#{nameFile}")
                        logger.error("sudo -n /usr/bin/rm -r -- '#{rutanew}#{nameFile}'")
                        system("sudo -n /usr/bin/rm -r -- '#{rutanew}#{nameFile}'")
                      end
                    else
                      file.close
                    end
                    #if cpi.id.to_i > 0
                    #  file.close
                    #  puts "para Elimionar2... el Archivo.. #{rutanew}#{nameFile}"
                    #  system("sudo rm -r '#{rutanew}#{nameFile}'")
                    #end
                  rescue Exception => ex1
                    logger.error("Errror.cargardigitales..." + ex1.message[0..1000].to_s)
                  end
                end
              end
          end
        rescue Exception => ex
          puts "*** Falla " + ex.message[0..1000].to_s
        end
      end
    end
    mensaje = "ASEAR: Proceso de cargue de Documentos Digitales, finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  # DatasController.cargardigitales(1,1)
  def self.cargardigitales2(idCarpeta, idUserId)
    system("sudo chmod 777 -R /home/archivo/ftp") 
    rutauploadfiles = "/home/archivo/ftp"
    namedirectory = ""
    Find.find(rutauploadfiles) do |f|
      type = case
      when File.directory?(f) then
        "D"
        puts "Encontre el Directorio... " + File.basename(f).to_s
        namedirectory = File.basename(f).to_s
        rutanew = rutauploadfiles + namedirectory.to_s + '/'
        begin
          Find.find(rutanew) do |fi|
            type = case
              when File.file?(fi) then
                "F"
                nameFile = File.basename(fi).to_s
                puts "Encontre el Archivo.. " + nameFile.to_s
                nmIdentificacion = nameFile.split(' ')[0].to_s
                nmIdentificacion = nmIdentificacion.gsub(' ', '').to_s
                personaId = Contratospersona.where(identificacion: nmIdentificacion).first.id rescue nil
                if personaId.present?
                  begin
                    puts "Archivo para cargar " + fi.to_s
                    file = File.open("#{fi.to_s}", 'rb')
                    if file.present?
                      cpi = Contratosperimagen.new
                      cpi.contratospersona_id = personaId
                      cpi.user_id = idUserId
                      cpi.personasimagen = file
                      cpi.descripcion = 'MASIVO - ' + namedirectory.upcase
                      cpi.estado = 'APROBADO'
                      cpi.save(validate: false)
                      file.close
                      if cpi.id.to_i > 0
                        rutanamefile = "#{rutanew.to_s}/#{fi.to_s}"
                        File.delete(rutanamefile) if File.exist?(rutanamefile)
                        # File.delete(file)
                        #puts "para Elimionar... el Archivo.. #{rutanew}#{nameFile}"
                        #system("sudo rm -r '#{rutanew}#{nameFile}'")
                      end
                    else
                      file.close
                    end
                  rescue Exception => ex1
                    puts "Errror...." + ex1.message[0..1000].to_s
                  end
                end
              end
          end
        rescue Exception => ex
          puts "*** Falla " + ex.message[0..1000].to_s
        end
      end
    end
    mensaje = "ASEAR: Proceso de cargue de Documentos Digitales, finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(idUserId, mensaje)
  end

  def self.notificarweek(idWeek)
    Objeto.find_by_sql("SELECT DISTINCT t.tema, d.user_persona user_id, u.email
                        FROM   tareas t, tareasactividades d, users u
                        WHERE  t.estado = 'ACTIVO' and t.id = #{idWeek}
                        AND    t.id = d.tarea_id
                        AND    d.user_persona = u.id").each do |p|
      puts "Enviado al email...." + p.email.to_s
      response = Asearmail::SendmailServices.new.general(p.email.to_s,
                                                         "Nuevo Week - #{p.tema.to_s}",
                                                         "asear_mailer/mondaynew.html.erb", nil, nil,
                                                         p.user_id)
      puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
    end
  end

  def self.consolidaliquidacion(nmConsecutivo)
    Contratosperliquidacion.select("id")
                           .where(["contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{nmConsecutivo})"]).each do |l|
      ActiveRecord::Base.connection.execute("CALL prc_consolidaliquidacion(#{l.id})")
    end
  end

  def descargardocbyproceso
    contratosperproceso = Contratosperproceso.find(params[:id].to_i)

    contratosperprodocs = contratosperproceso.contratosperprodocs rescue nil
    folder = "public/system/docprocesos/"
    folderform = "public/download/"
    nombreform = ""
    input_filenames = []
    input_fileids = []
    input_fileperiodo = []
    dinput_filenames = []
    dinput_fileids = []
    dinput_fileperiodo = []
    binput_filenames = []
    binput_fileids = []
    binput_fileperiodo = []
    if contratosperprodocs.present?
      i = 0
      contratosperprodocs.each do |d|
        input_filenames[i] = d.docproceso_file_name.to_s
        input_fileids[i] = d.id.to_s
        input_fileperiodo[i] = d.tipo.gsub(' ', '_').to_s rescue 'NN'
        i = i + 1
      end
      fname = "DocProceso_" + contratosperproceso.id.to_s + "_" + contratosperproceso.clase.capitalize.gsub(' ', '_').to_s + "_" + contratosperproceso.contratospersona.identificacion.to_s + '.zip'
      zipfile_folder = "public/download/" + fname
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        i = 0
        if input_filenames.present?
          input_filenames.each do |filename|
            ruta = input_fileids[i].to_s
            bashrc = File.join(folder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(input_fileperiodo[i].to_s + '_(' + input_fileids[i] + ')_' + filename, File.join(folder + ruta + '/original', filename))
            end
            i = i + 1
          end
        end
      end
    end
    if zipfile_folder.present?
      zip_data = File.read(zipfile_folder)
      send_data(zip_data, :type => 'application/zip', :filename => fname)
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
    else
      flash[:notice] = "Documentos no encontrados!!!"
      redirect_to editproceso_contratosperprocesos_path(id: contratosperproceso.id, contratospersona_id: contratosperproceso.contratospersona.id, etapa: '1')
    end
  end

  #DatasController.predownloadactivos
  def self.predownloadactivos
    Contrato.select("REPLACE(concat((select nombre from empresas where id = contratos.empresa_id),'_',contratos.nro_contrato),' ','_') nombree, contratos.id")
            .where("id in (166,495,520,538,589,728,755,781,785,805,807,823,827,831,832,834,840,843,844,846,
                           847,848,849,854,855,857,860,862,864,875,878,881,884,889,891,892,893,894,895,898,
                           909,910,912,916,918,931,934,935,946,951,952,955,956,957,961,962)").each do |cont|
      idC = cont.id
      datosearch = "contrato_id = #{idC} and estado = 'ACTIVO'".to_s
      fname1 = "DOCASEAR_#{cont.nombree.to_s}*"
      rutaFile = "#{::Rails.root}/public/download/" + fname1.to_s
      system("rm -r #{rutaFile}")

      dfolder = "public/system/personasimagenes/"
      folderform = "public/download/"
      nombreform = ""
      dinput_filenames = []
      dinput_fileids = []
      dinput_fileperiodo = []
      a = 0
      contratosdoc = Contratosperimagen.where("contratosperfecha_id in (select id from contratosperfechas where #{datosearch}) and descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%%'") rescue nil
      contratosdoc.each do |d|
        dinput_filenames[a] = d.personasimagen_file_name.to_s
        dinput_fileids[a] = d.id.to_s
        dinput_fileperiodo[a] = d.descripcion.to_s.upcase
        a = a + 1
      end

      fname = "DOCASEAR_#{cont.nombree.to_s}_#{Time.now.strftime("%Y%m%d").to_s}.zip"
      zipfile_folder = "public/download/" + fname
      File.delete(zipfile_folder) if File.exist?(zipfile_folder)
      Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
        a = 0
        dinput_filenames.each do |filename|
          ruta = dinput_fileids[a].to_s
          bashrc = File.join(dfolder + ruta + '/original', filename)
          if File.exist?(bashrc) # => true
            zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
          end
          a = a + 1
        end
      end
    end
  end

  def self.enviosms(personasformularioid, mensaje)
    Asearsms::SendsmsServices.new.send_sms_formulario(personasformularioid, mensaje)
  end

  def self.prcpersonasformularios(personasformularioid)
    ActiveRecord::Base.connection.execute("CALL prc_personasformularios(#{personasformularioid})")
  end

  private

  def determine_layout
    if ['descargarfile', 'download'].include?(action_name)
      "informes"
    else
      "informes"
    end
  end

end