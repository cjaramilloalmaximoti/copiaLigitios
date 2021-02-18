Utilidades = {

    MostrarConfirmacion: function (titulo, mensaje, funcionAceptar, funcionCancelar) {
        swal({
            title: titulo,
            text: mensaje,
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Si",
            cancelButtonText: "Cancelar",
            closeOnConfirm: true,
            closeOnCancel: true
        },
     function (isConfirm) {
         if (isConfirm && funcionAceptar) {
             funcionAceptar();
         } else {
             if (!isConfirm && funcionCancelar) {
                 funcionCancelar();
             }
         }
     });
    },

    MostrarDialogoError: function (titulo, mensaje, trace) {
        //swal(titulo, mensaje, "error");
        var html = null;
        if (trace) {
            html = '<div class="row bookTipografia">' +
                        '<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">' +
                            mensaje +
                         '</div>' +
                        '<div class="text-left col-xs-12 col-sm-12 col-md-12 col-lg-12">' +
                            '<a onmouseover="" class="linkVerDetalleError tamLetra bookTipografia" style="cursor: pointer;" onclick="linkVerDetalleError_Click(this)">Ver detalle</a>' +
                            '<textarea rows="6" class="form-control inputColumn inputpe tamLetra bookTipografia textArea hidden" id="txtDescripcionDetalleError" readonly title="Descripción del Error">' +
                                trace +
                            '</textarea> ' +
                         '</div>' +
                    '</div>';
            //html = mensaje + '<br /><br /><div class="form-control inputColumn inputpe tamLetra bookTipografia textArea" id="txtDescripcionDet" disabled="disabled" title="Descripción del Error">' + trace + '</div>';
        }
        else {
            html = mensaje;
        }
        swal({
            title: titulo,
            text: html,
            html: true,
            type: "error",
            showCancelButton: false,
            showConfirmButton: true,
            confirmButtonText: "Aceptar"
        });
    },

    MostrarDialogoErrorControlado: function (error) {
        var html = null;

        if (error.Respuesta.RespuestaInformacion) {
            html = '<div class="row bookTipografia">' +
                       '<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">' +
                           error.Respuesta.RespuestaInformacion.Data.Info.Mensaje +
                        '</div>' +
                        '<div class="text-left col-xs-12 col-sm-12 col-md-12 col-lg-12">' +
                            '<a onmouseover="" class="linkVerDetalleError tamLetra bookTipografia" style="cursor: pointer;" onclick="linkVerDetalleError_Click(this)">Ver detalle</a>' +
                            '<textarea rows="6" class="form-control inputColumn inputpe tamLetra bookTipografia textArea hidden" id="txtDescripcionDetalleError" readonly title="Descripción del Error">' +
                                error.Respuesta.RespuestaInformacion.Data.Info.Traza +
                            '</textarea> ' +
                         '</div>' +
                   '</div>';
        }
        else {
            html = '';
        }

        swal({
            title: error.Respuesta.MensajeUsuario,
            text: html,
            html: true,
            type: "error",
            showCancelButton: false,
            showConfirmButton: true,
            confirmButtonText: "Aceptar"
        });
    },

    MostrarDialogo: function (titulo, mensaje, noCerrarAutomaticamente) {
        if (noCerrarAutomaticamente) {
            swal({
                title: titulo,
                text: mensaje,
                type: 'success'
            });
        }
        else {
            swal({
                title: titulo,
                text: mensaje,
                type: 'success',
                timer: 3000
            });
        }
    },

    stringStartsWith: function (string, startsWith) {

        string = string || "";

        if (startsWith.length > string.length)

            return false;

        return string.substring(0, startsWith.length) === startsWith;

    },

    stringEqualTo: function (string, equal) {

        string = string || "";

        if (equal.length > string.length) {

            return false;

        }



        return string === equal;

    },

    mostrarFecha: function (dias) {

        milisegundos = parseInt(35 * 24 * 60 * 60 * 1000);



        fecha = new Date();

        //Obtenemos los milisegundos desde media noche del 1/1/1970

        tiempo = fecha.getTime();

        //Calculamos los milisegundos sobre la fecha que hay que sumar o restar...

        milisegundos = parseInt(dias * 24 * 60 * 60 * 1000);

        //Modificamos la fecha actual

        fecha.setTime(tiempo + milisegundos);

        return fecha;

    },

    validarDecimal: function (e, position, len, index, decimal, enteros) {

        var charCode = (e.which) ? e.which : e.keyCode

        if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode != 46 && charCode != 37 && charCode != 39))

            return false;

        else if (index > 0 && e.key == ".") {

            return false;

        }

        else {

            if (charCode == 8 || charCode == 9 || charCode == 37 || charCode == 39 || e.key == "Delete") {

                return true;

            }

            if (index > 0) {

                var CharAfterdot = (len + 1) - index;

                if (CharAfterdot > (decimal + 1) && position > index) {

                    return false;

                }

                else if (position >= enteros && index >= enteros) {

                    if (CharAfterdot < (decimal + 2) && position > index)

                    { return true; }

                    else {

                        return false;

                    }

                }

                else if (position < enteros && index >= enteros) {

                    return false;

                }

            }

            else {

                if ((len + 1) > enteros && (len + 1) <= enteros + 1) {

                    if (charCode == 46 || charCode == 8 || charCode == 9 || charCode == 37 || charCode == 39) {

                        return true;

                    }

                    else {

                        return false;

                    }

                }

                else if (index == 0 && (len + 1) > (decimal + 1)) {

                    return false;

                }

            }

        }

        return true;

    },

    validarEntero: function (e, len, enteros) {

        var charCode = (e.which) ? e.which : e.keyCode

        if (charCode > 31 && (charCode < 48 || charCode > 57))

            return false;

        else {

            if ((len + 1) > enteros) {

                return false;

            }

        }

        return true;

    },

    formatoMoneda: function (num, simbol) {

        this.simbol = simbol || '';

        num += '';

        var splitStr = num.split('.');

        var splitLeft = splitStr[0];

        var splitRight = splitStr.length > 1 ? "." + splitStr[1] : '';

        var regx = /(\d+)(\d{3})/;

        while (regx.test(splitLeft)) {

            splitLeft = splitLeft.replace(regx, '$1' + "," + '$2');

        }

        return this.simbol + (splitLeft != '' ? splitLeft : '0') + (splitRight != '' ? splitRight : '.00');

    },

    limpiarDecimalMoneda: function (cantidad) {

        var cantidadLimpia = cantidad.replace(/\$/g, '');

        cantidadLimpia = cantidadLimpia.replace(/\,/g, '');

        return cantidadLimpia;

    },

    limpiarForm: function (idFrom) {

        $(".input-validation-error").removeClass("input-validation-error");

        $('.field-validation-error').css('display', 'none');

    },

    ajustarDialog: function () {

        var alturaT = $("#dialog-content").height();

        var alturaC = $("#modal-dialog").height();

        if ((alturaT + 90) > alturaC) {

            $("#modal-content").height(alturaC - 90 + "px");

        }

        else {

            $("#modal-content").height("auto")

        }

    },

    MostrarCapturaNotas: function (visible, titulo, mensaje, funcionRechazar) {

        $('#rechazo-aceptar').unbind('click');

        $('#rechazo-aceptar').click(funcionRechazar);



        $('#rechazo-cancelar').unbind('click');

        $('#rechazo-cancelar').click(function () {

            $("#modal-rechazo-indicator").hide();

            $("#modal-rechazo").hide();

            $('#rechazo-title').html("");

            $('#rechazo-content').html("");

        });



        if (visible == true) {

            $('#modal-rechazo-indicator').show();

            $('#modal-rechazo').show();

            $('#rechazo-title').html(titulo);

            $('#rechazo-content').html(mensaje);

        }

        else {

            $("#modal-rechazo-indicator").hide();

            $("#modal-rechazo").hide();

            $('#rechazo-title').html("");

            $('#rechazo-content').html("");

        }

    },

    MostrarContrasena: function (visible, titulo, mensaje, funcion) {

        $('#contrasena-aceptar').unbind('click');

        $('#contrasena-aceptar').click(funcion);



        $('#contrasena-cancelar').unbind('click');

        $('#contrasena-cancelar').click(function () {

            $("#modal-contrasena-indicator").hide();

            $("#modal-contrasena").hide();

            $('#contrasena-title').html("");

            $('#contrasena-content').html("");

        });



        if (visible == true) {

            $('#modal-contrasena-indicator').show();

            $('#modal-contrasena').show();

            $('#contrasena-title').html(titulo);

            $('#contrasena-content').html(mensaje);

        }

        else {

            $("#modal-contrasena-indicator").hide();

            $("#modal-contrasena").hide();

            $('#contrasena-title').html("");

            $('#contrasena-content').html("");

        }

    },

    FormatoFecha: function (today) {



        //var today = new Date();

        var dd = today.getDate();

        var mm = today.getMonth() + 1; //January is 0!



        var yyyy = today.getFullYear();

        if (dd < 10) {

            dd = '0' + dd

        }

        if (mm < 10) {

            mm = '0' + mm

        }

        var today = dd + '/' + mm + '/' + yyyy;

        return today;

    },

    FormatoFechaIngles: function (today) {



        //var today = new Date();

        var dd = today.getDate();

        var mm = today.getMonth() + 1; //January is 0!



        var yyyy = today.getFullYear();

        if (dd < 10) {

            dd = '0' + dd

        }

        if (mm < 10) {

            mm = '0' + mm

        }

        var today = yyyy + '/' + mm + '/' + dd;

        return today;

    },

    truncate: function (valor, trunk) {

        var numero = valor.toString();



        numero = Utilidades.limpiarDecimalMoneda(numero);

        var onpoint = numero.split('.', 2);

        var numberStringTruncated = numero;

        if (onpoint.length > 1) {

            numberStringTruncated = onpoint[0] + '.' + onpoint[1].substring(0, trunk);

        }

        return parseFloat(numberStringTruncated);

    },

    AjaxCallModel: function (urlAjax, dataAjax, successAjax, errorAjax) {
        $.ajax({
            type: 'POST',
            url: urlAjax,
            data: dataAjax,
            cache: false,
            success: function (json) {
                if (json.Respuesta) {
                    var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
                    var codigoCorrecto = '"OK"';
                    if (codigoRegreso == codigoCorrecto) {
                        if (successAjax != null) {
                            successAjax(json);
                        }
                    }
                    else {
                        if (errorAjax != null) {
                            errorAjax(json);
                        }
                        else {
                            Utilidades.ErrorAjaxControlado(json);
                        }
                    }
                }
                else {
                    window.location.href = urlAccesoDenegado;
                }
            },
            error: function (json) {
                Utilidades.ErrorAjax(json);
                if (errorAjax != null) {
                    errorAjax(json);
                }
            }
        });
    },

    AjaxCallJson: function (urlAjax, dataAjax, successAjax, errorAjax) {
        var parametroJSON = '';
        if (dataAjax != null) {
            parametroJSON = JSON.stringify(dataAjax);
        }
        $.ajax({
            type: 'POST',
            url: urlAjax,
            headers: AddHeader(),
            data: parametroJSON,
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            beforeSend: function (data) {
                $('.btn').attr('disabled', true);
            },
            success: function (data) {
                $('.btn').attr('disabled', false);
                if (successAjax != null) {
                    successAjax(data);
                }
            },
            error: function (data) {
                $('.btn').attr('disabled', false);
                if (errorAjax != null)
                    errorAjax(data);
                else {
                    ErrorAjaxInternal(data);
                }
            }
        });
    },

    ErrorAjaxInternal: function (e) {
        if (null != e.responseText)
            ShowError(e.responseText, null, 1000, false);
        else
            location = '/Seguridad/SesionExpirada';
    },

    MostrarProgress: function () {
        document.getElementById('containerProgress').style.display = "block";
    },

    OcultarProgress: function () {
        document.getElementById('containerProgress').style.display = "none";
    },

    MostrarProgressContainer: function () {

        document.getElementById('containerProgressContainer').style.display = "block";
    },

    ActualizarProgressContainer: function (value) {

        if (value == 1)
            document.getElementById('containerProgressContainerPercent').style.display = "none";
        else
            document.getElementById('containerProgressContainerPercent').style.display = "block";

        document.getElementById('containerProgressContainerPercent').innerHTML = parseInt(value * 100) + '%';
    },

    OcultarProgressContainer: function () {

        document.getElementById('containerProgressContainerPercent').style.display = "none";
        document.getElementById('containerProgressContainer').style.display = "none";
    },

    MostrarProgressElementPopUp: function (element) {
        element.style.display = "block";
    },

    OcultarProgressElementPopUp: function (element) {
        element.style.display = "none";
    },

    MostrarProgressPopUp: function () {
        document.getElementById('containerProgressPopUp').style.display = "block";
    },

    OcultarProgressPopUp: function () {
        document.getElementById('containerProgressPopUp').style.display = "none";
    },

    ErrorAjax: function (error) {
        this.OcultarProgress();
        if (error.status && error.status == 200) {
            window.location.href = urlSesionFin;
        }
        else {
            this.MostrarDialogoError("Error", error.statusText, error.responseText);
        }
    },

    ErrorAjaxControlado: function (error) {
        this.OcultarProgress();
        this.MostrarDialogoErrorControlado(error);
    },

    ErrorAjaxPopUp: function (error) {
        this.OcultarProgressPopUp();
        if (error.status && error.status == 200) {
            window.location.href = urlSesionFin;
        }
        else {
            this.MostrarDialogoError("Error", error.statusText, error.responseText);
        }
    },

    ErrorAjaxControladoPopUp: function (error) {
        this.OcultarProgressPopUp();
        this.MostrarDialogoErrorControlado(error);
    },

    FormatearFechaMilisegundosString: function (valor) {
        if (valor && valor != null) {
            var date = new Date(parseFloat(valor.replace('/Date(', '').replace(')/', '')));
            var d = new Date(date || Date.now()),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();

            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;

            return [day, month, year].join('/');
        } else {
            return '';
        }
    },

    NumeroToString: function (valor) {
        //Seperates the components of the number
        var n = valor.toString().split(".");
        //Comma-fies the first part
        n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        //Combines the two sections
        return n.join(".");
    },

    NumeroToStringDecimales: function (valor, numeroDecimales) {
        //Seperates the components of the number
        var n = valor.toFixed(numeroDecimales).toString().split(".");
        //Comma-fies the first part
        n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        //Combines the two sections
        return n.join(".");
    },

    ProcesarFecha: function (fecha, formatoSalida) {

        var formatosFecha = {
            CORTO: 0,
            LARGO: 1,
            OBJETO: 2
        };

        if (formatoSalida == null)
            formatoSalida = formatosFecha.LARGO;

        var fechaNull = new Date(2000, 0, 1);
        var monthNames = [
        "Ene", "Feb", "Mar",
        "Abr", "May", "Jun", "Jul",
        "Ago", "Sep", "Oct",
        "Nov", "Dic"
        ];

        var objetoFecha;


        if (fecha instanceof Date) //es un objeto fecha
        {
            objetoFecha = fecha;
        }
        else { //otro formato de entrada

            var r = /\/Date\(([0-9]+)\)\//gi
            var matches = fecha.match(r);

            if (matches != null) {

                var result = matches.toString().substring(6, 19);
                var epochMilliseconds = result.replace(
                /^\/Date\(([0-9]+)([+-][0-9]{4})?\)\/$/,
                '$1');

                objetoFecha = new Date(parseInt(epochMilliseconds));
            }
            else {  //fecha como cadena

                var result = fecha.match(/^(\d{1,2})\/(Ene|Feb|Mar|Abr|May|Jun|Jul|Ago|Sep|Oct|Nov|Dic)\/(\d{4})$/); //asumo fecha valida

                if (result != null) {

                    for (var i = 0; i < monthNames.length; i++) {

                        if (fecha.includes(monthNames[i]))
                            fecha = fecha.replace(monthNames[i], '' + (i + 1) < 10 ? '0' + (i + 1) : (i + 1));

                    }

                }
                else {
                    if (fecha.match(/^(\d{1,2})\/(d{1,2})\/(\d{4})$/) == null) {
                        return '';
                    }
                }

                var pieces = fecha.split('/');
                objetoFecha = new Date(parseInt(pieces[2]), parseInt(pieces[1]) - 1, parseInt(pieces[0]));
            }
        }


        var curr_day = objetoFecha.getDate();
        var curr_month = objetoFecha.getMonth() + 1;
        var curr_year = objetoFecha.getFullYear();


        if (objetoFecha <= fechaNull) {
            return '';
        }

        var curr_day_str = curr_day < 10 ? '0' + curr_day : curr_day;


        switch (formatoSalida) {

            case formatosFecha.CORTO:
                {
                    var curr_month_str = curr_month < 10 ? '0' + curr_month : curr_month;
                    return curr_day_str + '/' + curr_month_str + '/' + curr_year;

                    break;
                }
            case formatosFecha.LARGO:
                {

                    return curr_day_str + '/' + monthNames[curr_month - 1] + '/' + curr_year;

                    break;
                }
            case formatosFecha.OBJETO:
                {
                    return objetoFecha;

                    break;
                }
            default:
                {
                    return ''
                }

        }

    },

    CargarDatos: function (url, params, slice, callback, errorAjaxControladoCallback, errorAjaxCallback) {

        params = params || {};

        params.slice = slice;

        params.file = $('#archivoDescarga').val();


        $.ajax({
            url: url,
            type: 'POST',
            cache: false,
            data: params,
            success: function (json) {

                var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
                var codigoCorrecto = '"OK"';

                if (codigoRegreso == codigoCorrecto) {

                    $('#archivoDescarga').val(json.ArchivoDescarga);

                    callback(json.Respuesta.RespuestaInformacion.Data.Info, json.EsPiezaFinal);

                    if (!json.EsPiezaFinal) {

                        Utilidades.CargarDatos(url, params, slice + 1, callback, errorAjaxControladoCallback, errorAjaxCallback);

                    }

                } else {

                    if (errorAjaxControladoCallback == null)
                        Utilidades.ErrorAjaxControlado(json);
                    else
                        errorAjaxControladoCallback(json);
                }

            },
            error: function (error) {
                if (errorAjaxCallback == null)
                    Utilidades.ErrorAjax(error);
                else
                    errorAjaxCallback(error);
            }
        });

    },

    ActivarIgnorarValidador: function (idForm) {
        var $form = $("#" + idForm);
        var $validator = $form.validate();

        // all errors
        //var $errors = $form.find(".field-validation-error span");

        // find just error attached to FireSrv_Size
        var $errors = $("#FireSrv_Size").next(".field-validation-error").find("span");

        // trick unobtrusive to think the elements were successfully validated
        // this removes the validation messages
        $errors.each(function () {
            $validator.settings.success($(this));
        });
    },

    StringFechaToDate: function (fechaString) {
        var dataSplit = fechaString.split('/');
        var dateConverted;
        if (dataSplit[2].split(" ").length > 1) {

            var hora = dataSplit[2].split(" ")[1].split(':');
            dataSplit[2] = dataSplit[2].split(" ")[0];
            dateConverted = new Date(dataSplit[2], dataSplit[1] - 1, dataSplit[0], hora[0], hora[1]);

        } else {
            dateConverted = new Date(dataSplit[2], dataSplit[1] - 1, dataSplit[0]);
        }
        return dateConverted;
    },

    UpdateUnobtrusiveValidations: function (idForm) {
        $(idForm).removeData("validator").removeData("unobtrusiveValidation");
        $.validator.unobtrusive.parse($(idForm));
    },
};

function DateTimePickerSpan_Click(control) {
    if (control && control != null && control != '') {
        $('#' + control).data("DateTimePicker").show();
    }
}
