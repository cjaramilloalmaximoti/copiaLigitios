var rutaCaracteristicas = null;
var IdOrigen_AcordCarac = null;
var Origen_AcordCarac = null;
var listaControles = null;
var obteniendoCatalogo = 0;
var IdProspectoCaracteristicaTemp = 0;

function InicializarControles_AcordCarac(rutaCaracteristicasTemp) {

    rutaCaracteristicas = rutaCaracteristicasTemp;

    $('#btnBuscar_AcordCarac').on('click', function () {

        var valido = true;
        try {
            valido = $("#userFormCaracteristicaFiltro").data('unobtrusiveValidation').validate();
        }
        catch (ex) {
            valido = false;
        }
        if (valido) {
            Utilidades.MostrarProgress();
            listaControles = null;
            $('#divFiltrosControles').empty();
            ObtenerListadoControlesDinamicos();
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha seleccionado alguna categoría.");
        }
    });
    
    $('#btnBuscar_AcordCarac2').on('click', function () {//MIO

        var valido = true;
        try {
            valido = $("#userFormCaracteristicaFiltro2").data('unobtrusiveValidation').validate();
        }
        catch (ex) {
            valido = false;
        }
        if (valido) {
            Utilidades.MostrarProgress();
            listaControles = null;
            $('#divFiltrosControles2').empty();
            ObtenerListadoControlesDinamicos2();//Cambiar
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha seleccionado alguna categoría.");
        }
    });

    $('#btnBuscarProsp2').on('click', function () {//MIO
        alert("AAA");
        var valido = true;
        try {
            valido = $("#userFormCaracteristicaControlesDinamicos2").data('unobtrusiveValidation').validate();
        }
        catch (ex) {
            valido = true;
        }

        if (valido) {
            var listaControlesGuardar = ObtenerValoresControles();
            alert("bbb");
            alert(listaControlesGuardar);
            /*
            if (listaControlesGuardar != null && listaControlesGuardar.length > 0) {
                Utilidades.MostrarProgress();
                var parametro = {
                    listaControles: listaControlesGuardar,
                    idOrigen: IdOrigen_AcordCarac,
                    origen: Origen_AcordCarac
                };
                Utilidades.AjaxCallModel(rutaCaracteristicas + 'InsProspectoCaracteristica', parametro, ValoresGuardados, null);
                $('#modalSeleccionarCaracteristica2').modal('hide');
            }
            else {
                Utilidades.MostrarDialogoError("Aviso", "No hay información a guardar.");
            }*/
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha capturado el valor de cada característica.");
        }
        $('#ddlCategoria').val([]);
        var valido = true;
        try {
            valido = $("#userFormCaracteristicaFiltro2").data('unobtrusiveValidation').validate();
        }
        catch (ex) {
            valido = false;
        }
        if (valido) {
            Utilidades.MostrarProgress();
            listaControles = null;
            $('#divFiltrosControles2').empty();
            ObtenerListadoControlesDinamicos2();//Cambiar
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha seleccionado alguna categoría.");
        }
    });


    $('#btnGuardarCaracteristicas').on('click', function () {
        var valido = true;
        try
        {
            valido=$("#userFormCaracteristicaControlesDinamicos").data('unobtrusiveValidation').validate();
        }
        catch(ex){
            valido = true;
        }

        if (valido) {
            var listaControlesGuardar = ObtenerValoresControles();
            if (listaControlesGuardar != null && listaControlesGuardar.length > 0) {
                Utilidades.MostrarProgress();
                var parametro = {
                    listaControles: listaControlesGuardar,
                    idOrigen: IdOrigen_AcordCarac,
                    origen: Origen_AcordCarac
                };
                Utilidades.AjaxCallModel(rutaCaracteristicas + 'InsProspectoCaracteristica', parametro, ValoresGuardados, null);
                $('#modalSeleccionarCaracteristica').modal('hide');
            }
            else {
                Utilidades.MostrarDialogoError("Aviso", "No hay información a guardar.");
            }
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha capturado el valor de cada característica.");
        }
    });

    $('#btnGuardarCaracteristicas2').on('click', function () {//MIO
        var valido = true;
        try {
            valido = $("#userFormCaracteristicaControlesDinamicos2").data('unobtrusiveValidation').validate();
        }
        catch (ex) {
            valido = true;
        }

        if (valido) {
            var listaControlesGuardar = ObtenerValoresControles();
            if (listaControlesGuardar != null && listaControlesGuardar.length > 0) {
                Utilidades.MostrarProgress();
                var parametro = {
                    listaControles: listaControlesGuardar,
                    idOrigen: IdOrigen_AcordCarac,
                    origen: Origen_AcordCarac
                };
                Utilidades.AjaxCallModel(rutaCaracteristicas + 'InsProspectoCaracteristica', parametro, ValoresGuardados, null);
                $('#modalSeleccionarCaracteristica2').modal('hide');
            }
            else {
                Utilidades.MostrarDialogoError("Aviso", "No hay información a guardar.");
            }
        }
        else {
            Utilidades.MostrarDialogoError("Aviso", "No ha capturado el valor de cada característica.");
        }
    });


    PrepararComboTiposControl_AcordCarac();
    //PrepararComboTiposControl_AcordCarac2();
}

function LimpiarControles_AcordCarac() {
    $('#ddlCategoria').val([]);
    $('#ddlCategoria').trigger('change');
    listaControles = null;
    $('#divFiltrosControles').empty();
    $('#ddlCategoria').prop("disabled", false);
    $('#btnBuscar_AcordCarac').show();
    /*
    $('#ddlCategoria2').val([]);
    $('#ddlCategoria2').trigger('change');
    listaControles = null;
    $('#divFiltrosControles2').empty();
    $('#ddlCategoria2').prop("disabled", false);
    $('#btnBuscar_AcordCarac2').show();*/
}

function PrepararComboTiposControl_AcordCarac() {
    $.ajax({
        url: rutaCaracteristicas + 'ObtenerCategorias',
        type: 'POST',
        cache: false,
        success: function (json) {
            var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);

            var codigoCorrecto = '"OK"';

            if (codigoRegreso == codigoCorrecto) {
                var lstCatalogos = json.Respuesta.RespuestaInformacion.Data.Info;
                $('#ddlCategoria').select2({
                    language: "es",
                    placeholder: "Selecciona una o varias opciones",
                    matcher: filterMatcher,
                    multiple: 'multiple',
                    allowClear: true,
                    data: lstCatalogos
                });
                
                $('#ddlCategoria2').select2({
                    language: "es",
                    placeholder: "Selecciona una o varias opciones",
                    matcher: filterMatcher,
                    multiple: 'multiple',
                    allowClear: true,
                    data: lstCatalogos
                });

            }
            else {
                Utilidades.ErrorAjaxControlado(json);
            }
        },
        error: function (xhr) {
            Utilidades.ErrorAjax(xhr);
        }
    });
}

/*function PrepararComboTiposControl_AcordCarac2() {
    $.ajax({
        url: rutaCaracteristicas + 'ObtenerCategorias',
        type: 'POST',
        cache: false,
        success: function (json) {
            var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);

            var codigoCorrecto = '"OK"';

            if (codigoRegreso == codigoCorrecto) {
                var lstCatalogos = json.Respuesta.RespuestaInformacion.Data.Info;
                
                $('#ddlCategoria2').select2({//MIO
                    language: "es",
                    placeholder: "Selecciona una o varias opciones",
                    matcher: filterMatcher,
                    multiple: 'multiple',
                    allowClear: true,
                    data: lstCatalogos
                });
            }
            else {
                Utilidades.ErrorAjaxControlado(json);
            }
        },
        error: function (xhr) {
            Utilidades.ErrorAjax(xhr);
        }
    });
}*/

function ObtenerListadoControlesDinamicos() {
    var idsCategoriaLocal = $('#ddlCategoria').val().join().toString();
    $.ajax({
        url: rutaCaracteristicas + 'ObtenerListadoControlesDinamicos',
        type: 'POST',
        cache: false,
        data: { idsCategoria: idsCategoriaLocal, idOrigen: IdOrigen_AcordCarac, origen: Origen_AcordCarac },
        success: function (json) {
            var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
            var codigoCorrecto = '"OK"';

            if (codigoRegreso == codigoCorrecto) {
                listaControles = json.Respuesta.RespuestaInformacion.Data.Info;
                GenerarControlesDinamicos();
                if (obteniendoCatalogo == 0) {
                    Utilidades.OcultarProgress();
                }
            }
            else {
                Utilidades.ErrorAjaxControlado(json);
            }
        },
        error: function (xhr) {
            Utilidades.ErrorAjax(xhr);
        }
    });
}


function ObtenerListadoControlesDinamicos2() {//MIO
    var idsCategoriaLocal = $('#ddlCategoria2').val().join().toString();
    $.ajax({
        url: rutaCaracteristicas + 'ObtenerListadoControlesDinamicos',
        type: 'POST',
        cache: false,
        data: { idsCategoria: idsCategoriaLocal, idOrigen: IdOrigen_AcordCarac, origen: Origen_AcordCarac },
        success: function (json) {
            var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
            var codigoCorrecto = '"OK"';

            if (codigoRegreso == codigoCorrecto) {
                listaControles = json.Respuesta.RespuestaInformacion.Data.Info;
                GenerarControlesDinamicos2();
                if (obteniendoCatalogo == 0) {
                    Utilidades.OcultarProgress();
                }
            }
            else {
                Utilidades.ErrorAjaxControlado(json);
            }
        },
        error: function (xhr) {
            Utilidades.ErrorAjax(xhr);
        }
    });
}


function GenerarControlesDinamicos() {
    var div = $("#divFiltrosControles");
    var divColumna = null;
    var divlabel = null;
    var divControl = null;
    var label = null;
    var chkBox = null;
    var controlChkBox = null;
    var lblChkBox = null;
    var spanChkBox = null;
    var control = null;
    var heightControl = '';
    $('#divFiltros').show();
    $.map(listaControles, function (filtro, index) {
        heightControl = '';
        switch (filtro.TipoControl) {
            case "RadCheckedDropDownListFiltro":
            case "RadAutoCompleteBox":
            case "Regex":
                heightControl = 'height: 100px;'
                break;
        }
        divColumna = $('<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6" style="margin-top:5px;' + heightControl + '"></div>');
        divColumna.attr("id", "div" + filtro.Control);
        
        controlChkBox = $('<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 checkboxBootstrap" style="height: 30px; margin-top: 5px;"></div>');
        lblChkBox = $('<label></label>');
        chkBox = $('<input type="checkbox" class="form-control inputColumn cajaTexto tamLetra bookTipografia chkAcordeonCaracteristica" name="chk' + filtro.NombreControl + '" id="chk' + filtro.NombreControl + '" value="" ' + (filtro.Valor && filtro.Valor != '' ? " checked=\"checked\"" : "") + '>');
        spanChkBox = $('<span class="cr"><i class="cr-icon fa fa-check"></i></span>');
        lblChkBox.append(chkBox);
        lblChkBox.append(spanChkBox);
        controlChkBox.append(lblChkBox);
        divColumna.append(controlChkBox);
        
        divlabel = $('<div class="col-xs-11 col-sm-4 col-md-3 col-lg-3"></div>');
        label = $('<label for="cmbLstReportHead2" id="lblLstReportHead2" class="labelColumn tamLetra regularTipografia">' + filtro.Caracteristica + '</label>');
        label.attr("id", "lbl" + filtro.NombreControl).text(filtro.Caracteristica);
        divlabel.append(label);
        divColumna.append(divlabel);

        divControl = $('<div class="col-xs-12 col-sm-7 col-md-8 col-lg-8"></div>');
        control = GenerarControl(filtro);
        if (control != null) {
            divControl.append(control);
        }
        divColumna.append(divControl);

        divColumna.appendTo(div);


        AplicarFormatoControl(filtro);
    });
    TriggerClickChkAcordeonCaracteristica();
    Utilidades.UpdateUnobtrusiveValidations("#userFormCaracteristicaControlesDinamicos");
}


function GenerarControlesDinamicos2() {//MIO
    var div = $("#divFiltrosControles2");
    var divColumna = null;
    var divlabel = null;
    var divControl = null;
    var label = null;
    var chkBox = null;
    var controlChkBox = null;
    var lblChkBox = null;
    var spanChkBox = null;
    var control = null;
    var heightControl = '';
    $('#divFiltros').show();
    $.map(listaControles, function (filtro, index) {
        heightControl = '';
        switch (filtro.TipoControl) {
            case "RadCheckedDropDownListFiltro":
            case "RadAutoCompleteBox":
            case "Regex":
                heightControl = 'height: 100px;'
                break;
        }
        divColumna = $('<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6" style="margin-top:5px;' + heightControl + '"></div>');
        divColumna.attr("id", "div" + filtro.Control);

        controlChkBox = $('<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1 checkboxBootstrap" style="height: 30px; margin-top: 5px;"></div>');
        lblChkBox = $('<label></label>');
        chkBox = $('<input type="checkbox" class="form-control inputColumn cajaTexto tamLetra bookTipografia chkAcordeonCaracteristica" name="chk' + filtro.NombreControl + '" id="chk' + filtro.NombreControl + '" value="" ' + (filtro.Valor && filtro.Valor != '' ? " checked=\"checked\"" : "") + '>');
        spanChkBox = $('<span class="cr"><i class="cr-icon fa fa-check"></i></span>');
        lblChkBox.append(chkBox);
        lblChkBox.append(spanChkBox);
        controlChkBox.append(lblChkBox);
        divColumna.append(controlChkBox);

        divlabel = $('<div class="col-xs-11 col-sm-4 col-md-3 col-lg-3"></div>');
        label = $('<label for="cmbLstReportHead" id="lblLstReportHead2" class="labelColumn tamLetra regularTipografia">' + filtro.Caracteristica + '</label>');
        label.attr("id", "lbl" + filtro.NombreControl).text(filtro.Caracteristica);
        divlabel.append(label);
        divColumna.append(divlabel);

        divControl = $('<div class="col-xs-12 col-sm-7 col-md-8 col-lg-8"></div>');
        control = GenerarControl(filtro);
        if (control != null) {
            divControl.append(control);
        }
        divColumna.append(divControl);

        divColumna.appendTo(div);


        AplicarFormatoControl(filtro);
    });
    TriggerClickChkAcordeonCaracteristica();
    Utilidades.UpdateUnobtrusiveValidations("#userFormCaracteristicaControlesDinamicos2");
}


function TriggerClickChkAcordeonCaracteristica() {
    $(".chkAcordeonCaracteristica").click(function () {
        var idControl = this.id.replace("chk","");
        if ($(this).is(':checked')) {            
            $('#' + idControl).prop("disabled", false);
        } else {
            $('#' + idControl).prop("disabled", true);
        }
    });
}


function TriggerClickChkAcordeonCaracteristica2() {
    $(".chkAcordeonCaracteristica").click(function () {
        var idControl = this.id.replace("chk", "");
        if ($(this).is(':checked')) {
            $('#' + idControl).prop("disabled", false);
        } else {
            $('#' + idControl).prop("disabled", true);
        }
    });
}


function GenerarControl(filtro) {
    var control = null;
    var span = null;
    var input = null;
    var spanMensaje = null;
    var controlInterno = null;

    switch (filtro.Control) {
        case "Fecha":
            control = $('<div></div>');
            controlInterno = $('<div class="input-group date"></div>');
            span = $('<span class="input-group-addon" control="' + filtro.NombreControl + '" onclick="DateTimePickerCaracteristicasSpan_Click(this)"><i class="fa fa-calendar"></i></span>');
            input = $('<input name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia datetimepickerZIndex" id="' + filtro.NombreControl + '" type="text" placeholder="' + filtro.FormatoControl.toLowerCase() + '" data-format="' + filtro.FormatoControl.toLowerCase().replace('mmmm', 'MM') + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + '>');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            controlInterno.append(span);
            controlInterno.append(input);
            control.append(controlInterno);
            control.append(spanMensaje);
            break;
        case "Dicotómico":
            control = $('<div class="checkboxBootstrap" style="height: 30px; margin-top: 5px;"></div>');
            var label = $('<label></label>');
            input = $('<input type="checkbox" class="form-control inputColumn cajaTexto tamLetra bookTipografia" name="' + filtro.NombreControl + '" id="' + filtro.NombreControl + '" value="" ' + (filtro.Valor && filtro.Valor.toUpperCase() == 'true'.toUpperCase() ? " checked=\"checked\"" : "") + '>');
            span = $('<span class="cr"><i class="cr-icon fa fa-check"></i></span>');
            label.append(input);
            label.append(span);
            control.append(label);
            break;
        case "Entero":
        case "Moneda":
            control = $('<div></div>');
            input = $('<input  type="text" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" data-val="true" data-val-regex-pattern="-?\\d+' + (filtro.NumeroDecimales && filtro.NumeroDecimales > 0 ? "(\\.\\d{1," + filtro.NumeroDecimales.toString() + "})?" : "") + '" data-val-regex="Formato incorrecto" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\"  required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Título":
            control = $('<div></div>');
            input = $('<input  type="text" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Párrafo":
            control = $('<div></div>');
            input = $('<textarea  rows ="3" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto inputpe tamLetra bookTipografia textArea" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Opcional":
            control = $('<div class="select2-wrapper"></div>');
            input = $('<select name="' + filtro.NombreControl + '" class="js-example-basic-single form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + '></select>');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
    }
    return control;
}


function GenerarControl2(filtro) {//MIO
    var control = null;
    var span = null;
    var input = null;
    var spanMensaje = null;
    var controlInterno = null;

    switch (filtro.Control) {
        case "Fecha":
            control = $('<div></div>');
            controlInterno = $('<div class="input-group date"></div>');
            span = $('<span class="input-group-addon" control="' + filtro.NombreControl + '" onclick="DateTimePickerCaracteristicasSpan_Click(this)"><i class="fa fa-calendar"></i></span>');
            input = $('<input name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia datetimepickerZIndex" id="' + filtro.NombreControl + '" type="text" placeholder="' + filtro.FormatoControl.toLowerCase() + '" data-format="' + filtro.FormatoControl.toLowerCase().replace('mmmm', 'MM') + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + '>');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            controlInterno.append(span);
            controlInterno.append(input);
            control.append(controlInterno);
            control.append(spanMensaje);
            break;
        case "Dicotómico":
            control = $('<div class="checkboxBootstrap" style="height: 30px; margin-top: 5px;"></div>');
            var label = $('<label></label>');
            input = $('<input type="checkbox" class="form-control inputColumn cajaTexto tamLetra bookTipografia" name="' + filtro.NombreControl + '" id="' + filtro.NombreControl + '" value="" ' + (filtro.Valor && filtro.Valor.toUpperCase() == 'true'.toUpperCase() ? " checked=\"checked\"" : "") + '>');
            span = $('<span class="cr"><i class="cr-icon fa fa-check"></i></span>');
            label.append(input);
            label.append(span);
            control.append(label);
            break;
        case "Entero":
        case "Moneda":
            control = $('<div></div>');
            input = $('<input  type="text" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" data-val="true" data-val-regex-pattern="-?\\d+' + (filtro.NumeroDecimales && filtro.NumeroDecimales > 0 ? "(\\.\\d{1," + filtro.NumeroDecimales.toString() + "})?" : "") + '" data-val-regex="Formato incorrecto" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\"  required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Título":
            control = $('<div></div>');
            input = $('<input  type="text" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Párrafo":
            control = $('<div></div>');
            input = $('<textarea  rows ="3" name="' + filtro.NombreControl + '" class="form-control inputColumn cajaTexto inputpe tamLetra bookTipografia textArea" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + ' value="">');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
        case "Opcional":
            control = $('<div class="select2-wrapper"></div>');
            input = $('<select name="' + filtro.NombreControl + '" class="js-example-basic-single form-control inputColumn cajaTexto tamLetra bookTipografia" id="' + filtro.NombreControl + '" ' + (filtro.Requerido ? " data-val-required=\"Dato requerido\" data-val=\"true\" required" : "") + '></select>');
            spanMensaje = $('<span class="text-danger tamLetra bookTipografia" data-valmsg-replace="true" data-valmsg-for="' + filtro.NombreControl + '"></span>')
            control.append(input);
            control.append(spanMensaje);
            break;
    }
    return control;
}


function DateTimePickerCaracteristicasSpan_Click(span) {
    var control = span.getAttribute("control");
    if (control && control != null && control != '') {
        $('#' + control).data("DateTimePicker").show();
    }
}

function AplicarFormatoControl(filtro) {
    switch (filtro.Control) {
        case "Fecha":
            $('#' + filtro.NombreControl).datetimepicker({
                locale: 'es',
                date: (filtro.Valor && filtro.Valor != '' ? Utilidades.StringFechaToDate(filtro.Valor) : new Date()),
                format: filtro.FormatoControl.toUpperCase()
            });/*.on('changeDate', function (e) {
                // Revalidate the date field
                $('#' + filtro.NombreControl).validate();
            });*/
            if (!(filtro.Valor && filtro.Valor != '')) {
                $('#' + filtro.NombreControl).prop("disabled", true);
            }
            break;
        case "Dicotómico":
            if (!(filtro.Valor && filtro.Valor != '')) {
                $('#' + filtro.NombreControl).prop("disabled", true);
            }
            break;
        case "Título":
        case "Entero":
        case "Moneda":
        case "Párrafo":
            if (!(filtro.Valor && filtro.Valor != '')) {
                $('#' + filtro.NombreControl).prop("disabled", true);
            }
            if (filtro.Valor && filtro.Valor != null && filtro.Valor != '') {
                $('#' + filtro.NombreControl).val(filtro.Valor);
            }
            break;
        case "Opcional":
            obteniendoCatalogo = obteniendoCatalogo + 1;
            var parametro = {
                IdCaracteristicaParticular: filtro.IdCaracteristicaParticular
            };
            Utilidades.AjaxCallModel(rutaCaracteristicas + 'ObtenerCatalogoCombo', parametro, ConfiguracionCombo, null);
            break;
    }
}

function ConfiguracionCombo(json) {
    var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
    var lstCatalogos = null;
    var filtroOriginal = null;
    var idFiltro = null;
    if (codigoRegreso == '"OK"') {
        idFiltro = json.Respuesta.IdCaracteristicaParticular;
        var $element = null;
        $.map(listaControles, function (filtro, index) {
            if (idFiltro == filtro.IdCaracteristicaParticular) {
                filtroOriginal = filtro;
            }
        });

        lstCatalogos = json.Respuesta.RespuestaInformacion.Data.Info;
        $element = $('#' + filtroOriginal.NombreControl).select2({
            language: "es",
            placeholder: "Selecciona una opción",
            matcher: filterMatcher,
            allowClear: true,
            data: lstCatalogos
        });

        

        if (filtroOriginal.Valor && filtroOriginal.Valor != null && filtroOriginal.Valor != '') {
            $('#' + filtroOriginal.NombreControl).val(filtroOriginal.Valor);
            $('#' + filtroOriginal.NombreControl).trigger('change');
        }
        else {

            $('#' + filtroOriginal.NombreControl).val(-1);
            $('#' + filtroOriginal.NombreControl).trigger('change');
        }


        if (!(filtroOriginal.Valor && filtroOriginal.Valor != '')) {
            $('#' + filtroOriginal.NombreControl).prop("disabled", true);
        }
    }
    obteniendoCatalogo = obteniendoCatalogo - 1;
    if (obteniendoCatalogo == 0) {
        Utilidades.OcultarProgress();
    }
}

function ObtenerValoresControles() {
    if (listaControles != null && listaControles.length > 0) {
        var arrayControles = null;
        var controlClone = null;
        $.map(listaControles, function (filtro, index) {
            if ($('#chk' + filtro.NombreControl).is(":checked")) {
                if (arrayControles == null) {
                    arrayControles = [];
                }
                controlClone = new Object();
                controlClone.IdCaracteristicaParticular = filtro.IdCaracteristicaParticular;
                controlClone.Caracteristica = filtro.Caracteristica;
                controlClone.Control = filtro.Control;
                controlClone.FormatoControl = filtro.FormatoControl;
                controlClone.NumeroDecimales = filtro.NumeroDecimales;
                controlClone.Requerido = filtro.Requerido;
                switch (filtro.Control) {
                    case "Fecha":
                    case "Título":
                    case "Entero":
                    case "Moneda":
                    case "Párrafo":
                        controlClone.Valor = $('#' + filtro.NombreControl).val() != null && $('#' + filtro.NombreControl).val() != '' ? $('#' + filtro.NombreControl).val().toString() : null;
                        break;
                    case "Dicotómico":
                        controlClone.Valor = $('#' + filtro.NombreControl).is(":checked").toString();
                        break;
                    case "Opcional":
                        controlClone.Valor = $('#' + filtro.NombreControl).val() != null ? $('#' + filtro.NombreControl).val().toString() : null;
                        break;
                }
                arrayControles.push(controlClone);
            }
        });
        return arrayControles;
    }
    return null;
}

function ValoresGuardados(json) {
    var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
    if (codigoRegreso == '"OK"') {
        Utilidades.OcultarProgress();
        ObtenerGrid_AcordCarac();
        Utilidades.MostrarDialogo("Aviso", "Registros guardados exitosamente.");
    }
}

function EliminarValorCaracteristica(IdProspectoCaracteristica) {
    IdProspectoCaracteristicaTemp = IdProspectoCaracteristica;
    Utilidades.MostrarConfirmacion('Aviso', 'Se eliminara el registro seleccionado, ¿Desea continuar?', EliminarValorCaracteristicaConfirm, EliminarValorCaracteristicaCancel);
}

function EliminarValorCaracteristicaConfirm() {
    Utilidades.MostrarProgress();
    var parametro = {
        IdProspectoCaracteristica: IdProspectoCaracteristicaTemp,
        origen: Origen_AcordCarac
    };
    Utilidades.AjaxCallModel(rutaCaracteristicas + 'EliProspectoCaracteristica', parametro, RegistoEliminado_AcordCarac, null);
}

function RegistoEliminado_AcordCarac(json) {
    var codigoRegreso = JSON.stringify(json.Respuesta.Codigo);
    if (codigoRegreso == '"OK"') {
        Utilidades.OcultarProgress();
        ObtenerGrid_AcordCarac();
        Utilidades.MostrarDialogo("Aviso", "Registro eliminado exitosamente.");
    }
}

function EliminarValorCaracteristicaCancel() {
    IdProspectoCaracteristicaTemp = 0;
}

function MostrarDetalleElementoSeleccionado_AcordCarac(Seleccionado) {
    LimpiarControles_AcordCarac();
    $('#ddlCategoria').prop("disabled", true);
    $('#btnBuscar_AcordCarac').hide();

    $('#modalSeleccionarCaracteristica').modal('show');
    listaControles = [];
    listaControles.push(Seleccionado);
    GenerarControlesDinamicos();
    if (obteniendoCatalogo == 0) {
        Utilidades.OcultarProgress();
    }
}



function filterMatcher(params, data) {
    data.parentText = data.parentText || "";

    // Always return the object if there is nothing to compare
    if ($.trim(params.term) === '') {
        return data;
    }

    // Do a recursive check for options with children
    if (data.children && data.children.length > 0) {
        // Clone the data object if there are children
        // This is required as we modify the object to remove any non-matches
        var match = $.extend(true, {}, data);

        // Check each child of the option
        for (var c = data.children.length - 1; c >= 0; c--) {
            var child = data.children[c];
            child.parentText += data.parentText + " " + data.text;

            var matches = filterMatcher(params, child);

            // If there wasn't a match, remove the object in the array
            if (matches == null) {
                match.children.splice(c, 1);
            }
        }

        // If any children matched, return the new object
        if (match.children.length > 0) {
            return match;
        }

        // If there were no matching children, check just the plain object
        return filterMatcher(params, match);
    }

    // If the typed-in term matches the text of this term, or the text from any
    // parent term, then it's a match.
    var original = (data.parentText + ' ' + data.text).toUpperCase();
    var term = params.term.toUpperCase();


    // Check if the text contains the term
    if (original.indexOf(term) > -1) {
        return data;
    }

    return null;
}