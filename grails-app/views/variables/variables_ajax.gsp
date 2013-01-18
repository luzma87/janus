%{--<ul class="nav nav-tabs" id="myTab">--}%
%{--<li class="active"><a href="#home" class="tab">Home</a></li>--}%
%{--<li><a href="#profile" class="tab">Profile</a></li>--}%
%{--<li><a href="#messages" class="tab">Messages</a></li>--}%
%{--<li><a href="#settings" class="tab">Settings</a></li>--}%
%{--</ul>--}%

%{--<div class="tab-content">--}%
%{--<div class="tab-pane active" id="home">home</div>--}%

%{--<div class="tab-pane" id="profile">prof</div>--}%

%{--<div class="tab-pane" id="messages">mes</div>--}%

%{--<div class="tab-pane" id="settings">set</div>--}%
%{--</div>--}%

%{--<script type="text/javascript">--}%
%{--$(function () {--}%

%{--$(".tab").click(function () {--}%
%{--var tab = $(this).parents("li").index();--}%
%{--console.log(tab);--}%
%{--$('#myTab li:eq(' + tab + ') a').tab('show');--}%

%{--//            var tab = $(this).attr("href");--}%
%{--//            $('#myTab a[href="#' + tab + '"]').tab('show');--}%
%{--//            $('#myTab a:last').tab('show');--}%
%{--return false;--}%
%{--});--}%

%{--//        $('#myTab a:last').tab('show');--}%

%{--//        $('#myTab a[href="#profile"]').tab('show'); // Select tab by name--}%
%{--//        $('#myTab a:first').tab('show'); // Select first tab--}%
%{--//        $('#myTab a:last').tab('show'); // Select last tab--}%
%{--//        $('#myTab li:eq(2) a').tab('show'); // Select third tab (0-indexed)--}%
%{--})--}%
%{--</script>--}%


<style type="text/css">
.tab {
    height     : 260px !important;
    overflow-x : hidden;
    overflow-y : auto;
}

.inputVar {
    width : 65px;
}

    /*.sum1 {*/
    /*background : #adff2f !important;*/
    /*}*/

    /*.sum2 {*/
    /*border : solid 2px green !important;*/
    /*}*/
</style>

<g:form controller="variables" action="saveVar_ajax" name="frmSave-var">
    <div id="tabs" style="height: 335px;">
        <ul>
            <li><a href="#tab-transporte">Variables de Transporte</a></li>
            <li><a href="#tab-factores">Factores</a></li>
            <li><a href="#tab-indirecto">Costos Indirectos</a></li>
        </ul>

        <div id="tab-transporte" class="tab">
            <div class="row-fluid">
                <div class="span3">
                    Volquete
                </div>

                <div class="span5">
                    <g:select name="volquete.id" id="cmb_vol" from="${volquetes}" optionKey="id" optionValue="nombre"
                              noSelection="${['': 'Seleccione']}" value="${obra?.volqueteId}"/>
                </div>

                <div class="span1">
                    Costo
                </div>

                <div class="span2">
                    %{--<div class="input-append">--}%
                    <g:textField class="inputVar" style="" disabled="" name="costo_volqueta" value=""/>
                    %{--<span class="add-on">$</span>--}%
                    %{--</div>--}%
                </div>
            </div>

            <div class="row-fluid">
                <div class="span3">
                    Chofer
                </div>

                <div class="span5">
                    <g:select name="chofer.id" id="cmb_chof" from="${choferes}" optionKey="id" optionValue="nombre"
                              noSelection="${['': 'Seleccione']}" value="${obra?.choferId}"/>
                </div>

                <div class="span1">
                    Costo
                </div>

                <div class="span2">
                    %{--<div class="input-append">--}%
                    <g:textField class="inputVar" name="costo_chofer" disabled=""/>
                    %{--<span class="add-on">$</span>--}%
                    %{--</div>--}%
                </div>
            </div>


            <div class="span6" style="margin-bottom: 20px; margin-top: 10px">

                <div class="span3" style="font-weight: bold;">

                    Distancia Peso

                </div>

                <div class="span2" style="font-weight: bold;">
                    Distancia Volumen

                </div>

            </div>


            <div class="row-fluid">

                <div class="span3">
                    Capital de Cantón
                </div>

                <div class="span3">
                    %{--<div class="input-append">--}%
                    <g:textField type="text" name="distanciaPeso" class="inputVar" value="${g.formatNumber(number: obra?.distanciaPeso, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                    %{--<span class="add-on">km</span>--}%
                    %{--</div>--}%
                </div>


                <div class="span3">
                    Materiales Petreos Hormigones
                </div>

                <div class="span1">
                    %{--<div class="input-append">--}%
                    <g:textField type="text" name="distanciaVolumen" class="inputVar" value="${g.formatNumber(number: obra?.distanciaVolumen, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                    %{--<span class="add-on">km</span>--}%
                    %{--</div>--}%
                </div>

            </div>

            <div class="row-fluid">

                <div class="span3">
                    Especial
                </div>

                <div class="span3">
                    %{--<div class="input-append">--}%
                    <g:textField type="text" name="distanciaPesoEspecial" class="inputVar" value="${g.formatNumber(number: obra?.distanciaPesoEspecial, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                    %{--<span class="add-on">km</span>--}%
                    %{--</div>--}%
                </div>

                <div class="span3">
                    Materiales Mejoramiento
                </div>

                <div class="span1">
                    %{--<div class="input-append">--}%
                    <g:textField type="text" name="distanciaVolumenMejoramiento" class="inputVar" value="${g.formatNumber(number: obra?.distanciaVolumenMejoramiento, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                    %{--<span class="add-on">km</span>--}%
                    %{--</div>--}%
                </div>

            </div>

            <div class="row-fluid">

                <div class="span3"></div>

                <div class="span3"></div>


                <div class="span3">
                    Materiales Carpeta Asfáltica
                </div>

                <div class="span1">
                    %{--<div class="input-append">--}%
                    <g:textField type="text" name="distanciaVolumenCarpetaAsfaltica" class="inputVar" value="${g.formatNumber(number: obra?.distanciaVolumenCarpetaAsfaltica, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                    %{--<span class="add-on">km</span>--}%
                    %{--</div>--}%
                </div>

            </div>

        </div>

        <div id="tab-factores" class="tab">
            <div class="row-fluid">
                <div class="span3">
                    Factor de reducción
                </div>

                <div class="span3">
                    <g:textField type="text" name="factorReduccion" class="inputVar" value="${g.formatNumber(number: obra?.factorReduccion, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>

                <div class="span3">
                    Velocidad
                </div>

                <div class="span3">
                    <g:textField type="text" name="factorVelocidad" class="inputVar" value="${g.formatNumber(number: obra?.factorVelocidad, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span3">
                    Capacidad Volquete
                </div>

                <div class="span3">
                    <g:textField type="text" name="capacidadVolquete" class="inputVar" value="${g.formatNumber(number: obra?.capacidadVolquete, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>

                <div class="span3">
                    Reducción/Tiempo
                </div>

                <div class="span3">
                    <g:textField type="text" name="factorReduccionTiempo" class="inputVar" value="${g.formatNumber(number: obra?.factorReduccionTiempo, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span3">
                    Factor Volumen
                </div>

                <div class="span3">
                    <g:textField type="text" name="factorVolumen" class="inputVar" value="${g.formatNumber(number: obra?.factorVolumen, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>

                <div class="span3">
                    Factor Peso
                </div>

                <div class="span3">
                    <g:textField type="text" name="factorPeso" class="inputVar" value="${g.formatNumber(number: obra?.factorPeso, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>
            </div>

            %{--<div class="row-fluid">--}%

            %{--<div class="span3">--}%
            %{--Distancia Volumen--}%
            %{--</div>--}%

            %{--<div class="span3">--}%
            %{--<g:textField type="text" name="distanciaVolumen" class="inputVar" value="0.00"/>--}%
            %{--</div>--}%

            %{--<div class="span3">--}%
            %{--Distancia Peso--}%
            %{--</div>--}%

            %{--<div class="span3">--}%
            %{--<g:textField type="text" name="distanciaPeso" class="inputVar" value="0.00"/>--}%
            %{--</div>--}%
            %{--</div>--}%
        </div>

        <div id="tab-indirecto" class="tab">
            <div class="row-fluid">
                <div class="span10">
                    Control y Administración (Fiscalización) - no se usa en obras nuevas
                </div>

                <div class="span2">
                    <g:textField type="text" name="contrato" class="inputVar" value="${g.formatNumber(number: obra?.contrato, maxFractionDigits: 2, minFractionDigits: 2)}"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Dirección de obra
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosObra" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosObra, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="1"/>
                </div>

                <div class="span4">
                    Promoción
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosPromocion" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosPromocion, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="7"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Mantenimiento y gastos de oficina
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosMantenimiento" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosMantenimiento, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="2"/>
                </div>

                <div class="span4 bold">
                    Gastos Generales (subtotal)
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceGastosGenerales" class="inputVar sum2" value="${g.formatNumber(number: obra?.indiceGastosGenerales, maxFractionDigits: 2, minFractionDigits: 2)}" disabled=""/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Administrativos
                </div>

                <div class="span2">
                    <g:textField type="text" name="administracion" class="inputVar sum1" value="${g.formatNumber(number: obra?.administracion, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="3"/>
                </div>

                <div class="span4 bold">
                    Imprevistos
                </div>

                <div class="span2">
                    <g:textField type="text" name="impreso" class="inputVar  sum2" value="${g.formatNumber(number: obra?.impreso, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="8"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Garantías
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosGarantias" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosGarantias, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="4"/>
                </div>

                <div class="span4 bold">
                    Utilidad
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceUtilidad" class="inputVar sum2 " value="${g.formatNumber(number: obra?.indiceUtilidad, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="9"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Costos financieros
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosCostosFinancieros" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosCostosFinancieros, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="5"/>
                </div>

                <div class="span4 bold">
                    Timbres provinciales
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosTimbresProvinciales" class="inputVar sum2" value="${g.formatNumber(number: obra?.indiceCostosIndirectosTimbresProvinciales, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="10"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    Vehículos
                </div>

                <div class="span2">
                    <g:textField type="text" name="indiceCostosIndirectosVehiculos" class="inputVar sum1" value="${g.formatNumber(number: obra?.indiceCostosIndirectosVehiculos, maxFractionDigits: 2, minFractionDigits: 2)}" tabindex="6"/>
                </div>

                <div class="span4 bold" style="border-top: solid 1px #D3D3D3;">
                    Total Costos Indirectos
                </div>

                <div class="span2">
                    <g:textField type="text" name="totales" class="inputVar" value="${g.formatNumber(number: obra?.totales, maxFractionDigits: 2, minFractionDigits: 2)}" disabled=""/>
                </div>
            </div>

        </div>
    </div>
</g:form>

<script type="text/javascript">

    $(".sum1, .sum2").keydown(function (ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         190        -> . teclado
         110        -> . teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         */
//        console.log(ev.keyCode);
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) || (ev.keyCode >= 96 && ev.keyCode <= 105) || ev.keyCode == 190 || ev.keyCode == 110 || ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9);
    });

    function suma(items, update) {
        var sum1 = 0;
        items.each(function () {
            sum1 += parseFloat($(this).val());
        });
        update.val(number_format(sum1, 2, ".", ""));
    }

    function costoItem($campo, $update) {
        var id = $campo.val();
        var fecha = $("#fechaPreciosRubros").val();
        var ciudad = $("#lugar\\.id").val();
//        console.log(id, fecha, ciudad);
        if (id != "" && fecha != "" && ciudad != "") {
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                data    : {
                    fecha  : fecha,
                    ciudad : ciudad,
                    ids    : id
                },
                success : function (msg) {
                    var precios = msg.split("&");
                    for (var i = 0; i < precios.length; i++) {
                        if ($.trim(precios[i]) != "") {
                            var parts = precios[i].split(";");
                            if (parts.length > 1) {
                                $update.val(parts[1].toString().trim());
                            }
                        }
                    }
                }
            });
        } else {
            $update.val("0.00");
        }
    }

    $(function () {
        $(".sum1").keyup(function (ev) {
            suma($(".sum1"), $("#indiceGastosGenerales"));
            suma($(".sum2"), $("#totales"));
        }).blur(function () {
                    suma($(".sum1"), $("#indiceGastosGenerales"));
                    suma($(".sum2"), $("#totales"));
                });
        $(".sum2").keyup(function (ev) {
            suma($(".sum2"), $("#totales"));
        }).blur(function () {
                    suma($(".sum2"), $("#totales"));
                });

        $("#tabs").tabs({
            heightStyle : "fill"
        });

        costoItem($("#cmb_vol"), $("#costo_volqueta"));
        costoItem($("#cmb_chof"), $("#costo_chofer"));

        $("#cmb_vol").change(function () {
            costoItem($(this), $("#costo_volqueta"));
        });
        $("#cmb_chof").change(function () {
            costoItem($(this), $("#costo_chofer"));
        });
    });

</script>