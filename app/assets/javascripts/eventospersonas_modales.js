// eventospersonas_modales.js

(function () {
    'use strict';

    // ── Estado global cámara ─────────────────────────────────────────────
    var camaraStream          = null;
    var editarCampoObjetivo   = null;
    var editarPreviewObjetivo = null;
    var editarEpId            = null;

    // ── Helper: spinner ──────────────────────────────────────────────────
    function spinnerHtml() {
        return '<div class="text-center" style="padding:50px 20px;">' +
            '<i class="fa fa-spinner fa-spin fa-2x text-muted"></i>' +
            '<p class="text-muted" style="margin-top:12px;">Cargando...</p>' +
            '</div>';
    }

    // ── Reinicializar plugins tras inyección AJAX ────────────────────────
    function inicializarPlugins(contexto) {

        // ── Select2 ──────────────────────────────────────────────────────
        if ($.fn.select2) {
            $(contexto).find('select').each(function () {
                $(this).select2({
                    width: '100%',
                    dropdownParent: $('#modal-editar-content') // ← apunta al contenedor del partial, no al modal wrapper
                });
            });
        }

        // ── jQuery UI Datepicker ─────────────────────────────────────────
        if (typeof $.fn.datepicker !== 'undefined') {
            var $dp = $(contexto).find('.datepicker');

            // Limpiar instancia previa (jQuery UI añade clase hasDatepicker)
            $dp.removeClass('hasDatepicker').datepicker('destroy');

            $dp.datepicker({
                dayNamesMin:     ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sáb'],
                monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                dateFormat:  'dd/mm/yy',   // yy = 4 dígitos en jQuery UI
                yearRange:   '1950:' + new Date().getFullYear(),
                changeMonth: true,
                changeYear:  true,
                maxDate:     new Date(),   // no permite fechas futuras
                showAnim:    'fadeIn',
                onSelect: function (dateText) {
                    // Guardar en formato yyyy-mm-dd para el servidor
                    var parts = dateText.split('/');         // dd / mm / yy
                    var iso   = parts[2] + '-' + parts[1] + '-' + parts[0];
                    $(this).data('isoValue', iso).trigger('change');
                }
            });

            // Prevenir escritura manual
            $dp.off('keydown.modal').on('keydown.modal', function (e) {
                if ([46, 8, 9, 27, 13].indexOf(e.keyCode) !== -1) { return; }
                e.preventDefault();
            });
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    //  MODAL DETALLE — carga lazy
    // ═══════════════════════════════════════════════════════════════════════
    $(document).on('click', '.btn-detalle-persona', function () {
        var id = $(this).data('id');
        $('#modal-detalle-content').html(spinnerHtml());
        $('#modal-detalle-global').modal('show');

        $.ajax({
            url:      '/eventospersonas/' + id,
            type:     'GET',
            dataType: 'html',
            success: function (html) {
                $('#modal-detalle-content').html(html);
            },
            error: function () {
                $('#modal-detalle-content').html(
                    '<div class="modal-body text-center text-danger" style="padding:40px;">' +
                    '<i class="fa fa-exclamation-triangle fa-2x"></i>' +
                    '<p style="margin-top:10px;">No se pudo cargar el detalle. Intenta de nuevo.</p>' +
                    '<button class="btn btn-default" data-dismiss="modal">Cerrar</button>' +
                    '</div>'
                );
            }
        });
    });

    $('#modal-detalle-global').on('hidden.bs.modal', function () {
        $('#modal-detalle-content').html('');
    });

    // ═══════════════════════════════════════════════════════════════════════
    //  MODAL EDITAR — carga lazy
    // ═══════════════════════════════════════════════════════════════════════
    function cargarModalEditar(id) {
        $('#modal-editar-content').html(spinnerHtml());
        $('#modal-editar-global').modal('show');

        $.ajax({
            url:      '/eventospersonas/' + id + '/edit',
            type:     'GET',
            dataType: 'html',
            success: function (html) {
                $('#modal-editar-content').html(html);

                // ✅ Reinicializar select2, datepicker, etc.
                inicializarPlugins('#modal-editar-content');

                // Si venimos de la cámara, restaurar imagen capturada
                if (window._camaraBase64Temp && window._camaraPreviewObjetivo) {
                    var prefijo     = window._camaraPreviewObjetivo;
                    var campoId     = 'editar-cedula-' + prefijo + '-' + id;
                    var hiddenField = document.getElementById(campoId);
                    var previewDiv  = document.getElementById('editar-preview-' + prefijo + '-' + id);
                    var previewImg  = document.getElementById('editar-preview-' + prefijo + '-img-' + id);

                    if (hiddenField) { hiddenField.value = window._camaraBase64Temp; }
                    if (previewDiv && previewImg) {
                        previewImg.src           = 'data:image/jpeg;base64,' + window._camaraBase64Temp;
                        previewDiv.style.display = 'block';
                    }

                    window._camaraBase64Temp      = null;
                    window._camaraPreviewObjetivo = null;
                }
            },
            error: function () {
                $('#modal-editar-content').html(
                    '<div class="modal-body text-center text-danger" style="padding:40px;">' +
                    '<i class="fa fa-exclamation-triangle fa-2x"></i>' +
                    '<p style="margin-top:10px;">No se pudo cargar el formulario. Intenta de nuevo.</p>' +
                    '<button class="btn btn-default" data-dismiss="modal">Cerrar</button>' +
                    '</div>'
                );
            }
        });
    }

    $(document).on('click', '.btn-editar-persona', function () {
        cargarModalEditar($(this).data('id'));
    });

    // Solo limpiar si NO estamos en flujo de cámara
    $('#modal-editar-global').on('hidden.bs.modal', function () {
        if (!editarEpId) {
            $('#modal-editar-content').html('');
        }
    });

    // ═══════════════════════════════════════════════════════════════════════
    //  ENVÍO AJAX — formulario editar (delegado, el form es dinámico)
    // ═══════════════════════════════════════════════════════════════════════
    $(document).on('submit', '[id^="form-editar-"]', function (e) {
        e.preventDefault();
        var form = $(this);
        var btn  = form.find('button[type="submit"]');
        var textoOriginal = btn.html();

        btn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Guardando...');

        $.ajax({
            url:  form.attr('action'),
            type: 'PATCH',
            data: form.serialize(),
            success: function () {
                $('#modal-editar-global').modal('hide');
                setTimeout(function () { location.reload(); }, 400);
            },
            error: function (xhr) {
                btn.prop('disabled', false).html(textoOriginal);
                var msg = 'Error al guardar los cambios.';
                try {
                    var json = JSON.parse(xhr.responseText);
                    if (json.errors) { msg = json.errors.join('\n'); }
                } catch (ex) { /* noop */ }
                alert(msg);
            }
        });
    });

    // ═══════════════════════════════════════════════════════════════════════
    //  LIGHTBOX
    // ═══════════════════════════════════════════════════════════════════════
    window.abrirImagen = function (url, titulo) {
        $('#lightbox-img').attr('src', url);
        $('#lightbox-titulo').text(titulo);
        $('#lightbox-doc').css('display', 'flex');
    };

    window.cerrarLightbox = function () {
        $('#lightbox-doc').css('display', 'none');
        $('#lightbox-img').attr('src', '');
    };

    document.getElementById('lightbox-doc').addEventListener('click', function (e) {
        if (e.target === this) { window.cerrarLightbox(); }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') { window.cerrarLightbox(); }
    });

    // ═══════════════════════════════════════════════════════════════════════
    //  CÁMARA — abrir desde modal editar
    // ═══════════════════════════════════════════════════════════════════════
    window.abrirCamaraEditar = function (prefixPreview, campoId, epId) {
        editarCampoObjetivo   = campoId;
        editarPreviewObjetivo = prefixPreview;
        editarEpId            = epId;

        $('#modal-editar-global').one('hidden.bs.modal', function () {
            document.getElementById('modal-titulo').innerHTML =
                '<i class="fa fa-camera"></i> ' +
                (prefixPreview === 'frente' ? 'Capturar Documento \u2013 Frente'
                    : 'Capturar Documento \u2013 Reverso');

            document.getElementById('camara-canvas').style.display    = 'none';
            document.getElementById('camara-video').style.display     = 'block';
            document.getElementById('footer-capturar').style.display  = 'flex';
            document.getElementById('footer-confirmar').style.display = 'none';
            document.getElementById('camara-guia').style.display      = 'flex';
            document.getElementById('camara-error').style.display     = 'none';

            $('#modalCamara').modal('show');
        });

        $('#modal-editar-global').modal('hide');
    };

    // Iniciar stream al abrir cámara
    $('#modalCamara').on('show.bs.modal', function () {
        var video = document.getElementById('camara-video');
        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
                .then(function (stream) {
                    camaraStream    = stream;
                    video.srcObject = stream;
                })
                .catch(function () {
                    document.getElementById('camara-error').style.display = 'flex';
                    document.getElementById('camara-video').style.display = 'none';
                    document.getElementById('camara-guia').style.display  = 'none';
                });
        } else {
            document.getElementById('camara-error').style.display = 'flex';
        }
    });

    // Detener stream + reabrir modal editar al cerrar cámara
    $('#modalCamara').on('hidden.bs.modal', function () {
        if (camaraStream) {
            camaraStream.getTracks().forEach(function (t) { t.stop(); });
            camaraStream = null;
        }

        if (editarEpId) {
            var idParaReabrir = editarEpId;
            editarEpId = null;

            setTimeout(function () {
                cargarModalEditar(idParaReabrir);
            }, 300);
        }
    });

    // Botón SNAP
    document.getElementById('btn-snap').addEventListener('click', function () {
        var video  = document.getElementById('camara-video');
        var canvas = document.getElementById('camara-canvas');
        canvas.width  = video.videoWidth;
        canvas.height = video.videoHeight;
        canvas.getContext('2d').drawImage(video, 0, 0);

        var flash = document.getElementById('camara-flash');
        flash.style.opacity = '1';
        setTimeout(function () { flash.style.opacity = '0'; }, 150);

        video.style.display                                        = 'none';
        canvas.style.display                                       = 'block';
        document.getElementById('camara-guia').style.display      = 'none';
        document.getElementById('footer-capturar').style.display  = 'none';
        document.getElementById('footer-confirmar').style.display = 'flex';
    });

    // Botón REPETIR
    document.getElementById('btn-repetir').addEventListener('click', function () {
        document.getElementById('camara-canvas').style.display    = 'none';
        document.getElementById('camara-video').style.display     = 'block';
        document.getElementById('camara-guia').style.display      = 'flex';
        document.getElementById('footer-capturar').style.display  = 'flex';
        document.getElementById('footer-confirmar').style.display = 'none';
    });

    // Botón USAR FOTO
    document.getElementById('btn-usar-foto').addEventListener('click', function () {
        var dataUrl = document.getElementById('camara-canvas').toDataURL('image/jpeg', 0.85);
        var base64  = dataUrl.split(',')[1];

        window._camaraBase64Temp      = base64;
        window._camaraPreviewObjetivo = editarPreviewObjetivo;

        $('#modalCamara').modal('hide');
    });

}());