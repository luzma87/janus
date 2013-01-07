<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Rubros
    </title>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">
</head>

<body>

<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="span12 btn-group" role="navigation">
    <a href="#" class="btn  " id="btn_lista">
        <i class="icon-file"></i>
        Lista
    </a>
    <a href="${g.createLink(action: 'rubroPrincipal')}" class="btn btn-ajax btn-new">
        <i class="icon-file"></i>
        Nuevo
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="guardar">
        <i class="icon-file"></i>
        Guardar
    </a>
    <a href="${g.createLink(action: 'rubroPrincipal')}" class="btn btn-ajax btn-new">
        <i class="icon-file"></i>
        Cancelar
    </a>
    <a href="#" class="btn btn-ajax btn-new">
        <i class="icon-file"></i>
        Borrar
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="calcular" title="Calcular precios">
        <i class="icon-table"></i>
        Calcular
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="transporte" title="Transporte">
        <i class="icon-truck"></i>
        Transporte
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="imprimir" title="Imprimir">
        <i class="icon-print"></i>
        Imprimir
    </a>

    %{--<a href="${g.createLink(controller: 'pdf',action: 'pdfLink',params: [url:g.createLink(controller: 'reportes3',action: 'imprimirRubro',id: rubro?.id)])}" class="btn btn-ajax btn-new" id="imprimir" title="Imprimir">--}%
    %{--<i class="icon-print"></i>--}%
    %{--Imprimir--}%
    %{--</a>--}%
</div>


<div id="list-grupo" class="span12" role="main" style="margin-top: 10px;margin-left: -10px">

<div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;">
    <g:form class="frmRubro" action="save">
        <input type="hidden" id="rubro__id" name="rubro.id" value="${rubro?.id}">

        <p class="css-vertical-text">Rubro</p>

        <div class="linea" style="height: 100px;"></div>

        <div class="row-fluid">
            <div class="span2">
                Código
                <input type="text" name="rubro.codigo" class="span24" value="${rubro?.codigo}">
            </div>

            <div class="span6">
                Descripción
                <input type="text" name="rubro.nombre" class="span72" value="${rubro?.nombre}">
            </div>

            <div class="span1" style="border: 0px solid black;height: 45px;padding-top: 18px">

                <div class="btn-group" data-toggle="buttons-checkbox">
                    <button type="button" id="rubro_registro" class="btn btn-info ${(rubro?.registro == 'R') ? 'active registrado' : ""}" style="font-size: 10px">Registrado</button>
                </div>
                <input type="hidden" id="registrado" name="rubro.registro" value="${rubro?.registro}">

            </div>

            <div class="span2">
                Fecha registro
                <elm:datepicker name="rubro.fechaReg" class="span24" value="${rubro?.fechaRegistro}" disabled="true" id="fechaReg"/>
            </div>

        </div>
        <div class="row-fluid">
            <div class="span2"  >
                Clase
                <g:select name="rubro.grupo.id" id="selClase" from="${grupos}" class="span12" optionKey="id" optionValue="descripcion"
                          value="${rubro?.departamento?.subgrupo?.grupo?.id}" noSelection="['': '--Seleccione--']"/>
            </div>
            <div class="span2">
                Grupo
                <g:if test="${rubro?.departamento?.subgrupo?.id}">
                    <g:select id="selGrupo" name="rubro.suggrupoItem.id" from="${janus.SubgrupoItems.findAllByGrupo(rubro?.departamento?.subgrupo?.grupo)}"
                              class="span12" optionKey="id" optionValue="descripcion" value="${rubro?.departamento?.subgrupo?.id}" noSelection="['': '--Seleccione--']"/>
                </g:if>
                <g:else>
                    <select id="selGrupo" class="span12"></select>
                </g:else>
            </div>

            <div class="span3">
                Sub grupo
                <g:if test="${rubro?.departamento?.id}">
                    <g:select name="rubro.departamento.id" id="selSubgrupo" from="${janus.DepartamentoItem.findAllBySubgrupo(rubro?.departamento?.subgrupo)}"
                              class="span12" optionKey="id" optionValue="descripcion" value="${rubro?.departamento?.id}"/>
                </g:if>
                <g:else>
                    <select id="selSubgrupo" class="span12"></select>
                </g:else>
            </div>

            <div class="span3">
                Unidad
                <g:select name="rubro.unidad.id" from="${janus.Unidad.list()}" class="span12" optionKey="id" optionValue="descripcion" value="${rubro?.unidad?.id}"/>
            </div>


            %{--<div class="span2"  >--}%
            %{--Rendimiento--}%
            %{--<input type="text" name="rubro.rendimiento" class="span24">--}%
            %{--</div>--}%

        </div>
    </g:form>
</div>

<div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 10px;position: relative;">
    <p class="css-vertical-text">Items</p>

    <div class="linea" style="height: 100px;"></div>

    <div class="row-fluid">
        %{--<div class="span3">--}%
        %{--<div style="height: 40px;float: left;width: 100px">Lista de precios</div>--}%

        %{--<div class="btn-group span7" data-toggle="buttons-radio" style="float: right;">--}%
        %{--<button type="button" class="btn btn-info active tipoPrecio" id="C">Civiles</button>--}%
        %{--<button type="button" class="btn btn-info tipoPrecio" id="V">Viales</button>--}%
        %{--</div>--}%
        %{--</div>--}%

        <div class="span4">
            Lista
            <g:select name="item.ciudad.id" from="${janus.Lugar.list()}" optionKey="id" optionValue="descripcion" class="span10" id="ciudad"/>
        </div>

        <div class="span2">
            Fecha
            <elm:datepicker name="item.fecha" class="span8" id="fecha_precios" value="${new java.util.Date()}" format="dd-MM-yyyy"/>
        </div>

        <g:if test="${!items}">
            <div class="span2">
                <a class="btn btn-small btn-warning " href="#" rel="tooltip" title="Copiar " id="btn_copiarComp">
                    Copiar composición
                </a>
            </div>
        </g:if>
        <div class="span3">
            % costos indriectos
            <input type="text" style="width: 30px;" id="costo_indi" value="21.5">
        </div>

    </div>

    <div class="row-fluid" style="margin-bottom: 5px">
        <div class="span2">
            Código
            <input type="text" name="item.codigo" id="cdgo_buscar" class="span24">
            <input type="hidden" id="item_id">
        </div>

        <div class="span6">
            Descripción
            <input type="text" name="item.descripcion" id="item_desc" class="span72">
        </div>

        <div class="span1">
            Unidad
            <input type="text" name="item.unidad" id="item_unidad" class="span8">
        </div>

        <div class="span1">
            Cantidad
            <input type="text" name="item.cantidad" class="span12" id="item_cantidad" value="1" style="text-align: right">
        </div>

        <div class="span1">
            Rendimiento
            <input type="text" name="item.rendimiento" class="span12" id="item_rendimiento" value="1" style="text-align: right">
        </div>

        <div class="span1" style="border: 0px solid black;height: 45px;padding-top: 22px">
            <a class="btn btn-small btn-primary btn-ajax" href="#" rel="tooltip" title="Agregar" id="btn_agregarItem">
                <i class="icon-plus"></i>
            </a>
        </div>

    </div>
</div>

<input type="hidden" id="actual_row">
<div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;float: left;width: 95%" id="tablas">
    <p class="css-vertical-text">Composición</p>

    <div class="linea" style="height: 98%;"></div>
    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Equipo
            </th>
            <th style="width: 80px;">
                Cantidad
            </th>
            <th class="col_tarifa" style="display: none;">Tarifa</th>
            <th class="col_hora" style="display: none;">C.Hora</th>
            <th class="col_rend" style="width: 50px">Rendimiento</th>
            <th class="col_total" style="display: none;">C.Total</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_equipo">
        <g:each in="${items}" var="rub" status="i">
            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">
                <tr class="item_row" id="${rub.id}">
                    <td class="cdgo">${rub.item.codigo}</td>
                    <td>${rub.item.nombre}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>

                    <td class="col_tarifa" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                    <td class="col_hora" style="display: none;text-align: right"></td>
                    <td class="col_rend rend" style="width: 50px;text-align: right">
                        <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" />
                    </td>
                    <td class="col_total" style="display: none;text-align: right"></td>
                    <td style="width: 40px;text-align: center" class="col_delete">
                        <a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                            <i class="icon-trash"></i></a>
                    </td>
                </tr>
            </g:if>
        </g:each>
        </tbody>
    </table>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Mano de obra
            </th>
            <th style="width: 80px">
                Cantidad
            </th>

            <th class="col_jornal" style="display: none;"  >Jornal</th>
            <th class="col_hora" style="display: none;">C.Hora</th>
            <th class="col_rend" style="width: 50px;">Rendimiento</th>
            <th class="col_total" style="display: none;">C.Total</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_mano">
        <g:each in="${items}" var="rub" status="i">
            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                <tr class="item_row" id="${rub.id}">
                    <td class="cdgo">${rub.item.codigo}</td>
                    <td>${rub.item.nombre}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                    </td>

                    <td class="col_jornal" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                    <td class="col_hora" style="display: none;text-align: right"></td>
                    <td class="col_rend rend" style="width: 50px;text-align: right">
                        <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                    </td>
                    <td class="col_total" style="display: none;text-align: right"></td>
                    <td style="width: 40px;text-align: center" class="col_delete">
                        <a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                            <i class="icon-trash"></i></a>
                    </td>
                </tr>
            </g:if>
        </g:each>
        </tbody>
    </table>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Material
            </th>
            <th style="width: 60px" class="col_unidad">
                Unidad
            </th>
            <th style="width: 80px">
                Cantidad
            </th>
            <th style="width: 40px" class="col_delete"></th>
            <th class="col_precioUnit" style="display: none;">Unitario</th>
            <th class="col_vacio" style="width: 55px;display: none"></th>
            <th class="col_vacio" style="width: 55px;display: none"></th>
            <th class="col_total" style="display: none;">C.Total</th>
        </tr>
        </thead>
        <tbody id="tabla_material">
        <g:each in="${items}" var="rub" status="i">
            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">
                <tr class="item_row" id="${rub.id}">
                    <td class="cdgo">${rub.item.codigo}</td>
                    <td>${rub.item.nombre}</td>
                    <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td class="col_precioUnit" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                    <td class="col_vacio" style="width: 50px;display: none;"></td>
                    <td class="col_vacio" style="width: 50px;display: none"></td>
                    <td class="col_total" style="display: none;text-align: right"></td>
                    <td style="width: 40px;text-align: center" class="col_delete">
                        <a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                            <i class="icon-trash"></i></a>
                    </td>
                </tr>
            </g:if>
        </g:each>
        </tbody>
    </table>
    <div id="tabla_transporte"></div>
    <div id="tabla_indi"></div>
    <div id="tabla_costos" style="height: 120px;display: none;float: right;width: 100%;margin-bottom: 10px;"></div>
</div>

</div>

<div class="modal grande hide fade " id="modal-rubro" style=";overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="rubro.buscador.id" value="" accion="buscaRubro" controlador="rubro" campos="${campos}" label="Rubro" tipo="lista"/>
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>
<div class="modal hide fade " id="modal-transporte" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modal_trans_title" >
            Variables de transporte
        </h3>
    </div>

    <div class="modal-body" id="modal_trans_body">
        <div class="row-fluid">
            <div class="span8">
                Volquete
                <g:select name="volquetes" from="${volquetes}" optionKey="id" optionValue="nombre" id="cmb_vol" noSelection="${['-1':'Seleccione']}" value="${aux.volquete.id}"></g:select>
            </div>
            <div class="span4">
                Costo <input type="text" style="width: 50px;text-align: right" disabled="" id="costo_volqueta">
            </div>
        </div>
        <div class="row-fluid">
            <div class="span8">
                Chofer
                <g:select name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof" style="margin-left: 13px" noSelection="${['-1':'Seleccione']}" value="${aux.chofer.id}" ></g:select>
            </div>
            <div class="span4">
                Costo <input type="text" style="width: 50px;text-align: right" disabled="" id="costo_chofer" >
            </div>
        </div>
        <div class="row-fluid">
            <div class="span6">
                Distancia peso
                <input type="text" style="width: 50px;" id="dist_peso" value="0.00">
            </div>
            <div class="span5" style="margin-left: 30px;">
                Distancia volumen <input type="text" style="width: 50px;" id="dist_vol" value="0.00">
            </div>
        </div>

    </div>

    <div class="modal-footer" id="modal_trans_footer">
        <a href="#" data-dismiss="modal" class="btn">OK</a>
    </div>
</div>
<script type="text/javascript">
    function enviarItem() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'buscaItem')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });

    }

    function enviarCopiar() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'buscaRubroComp')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function transporte(){
        var dsps=$("#dist_peso").val()
        var dsvs=$("#dist_vol").val()
        var volqueta=$("#costo_volqueta").val()
        var chofer=$("#costo_chofer").val()

        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'transporte')}",
            data     : "dsps="+dsps+"&dsvs="+dsvs+"&prvl="+volqueta+"&prch="+chofer+"&fecha="+$("#fecha_precios").val()+"&id=${rubro?.id}&lugar="+$("#ciudad").val(),
            success  : function (msg) {
                $("#tabla_transporte").html(msg)
                tablaIndirectos();
            }
        });

    }

    function totalEquipos(){
        var trE=$("<tr id='total_equipo' class='total'>")
        var equipos = $("#tabla_equipo").children()
        var totalE= 0
        var td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trE.append(td)
        for(i=0;i<5;i++){
            td=$("<td>")
            trE.append(td)
        }

        equipos.each(function(){
            totalE+=parseFloat($(this).find(".col_total").html())
        })

        td=$("<td class='valor_total'  style='text-align: right;;font-weight: bold'>")
        td.html(number_format(totalE, 5, ".", ""))
        trE.append(td)
        $("#tabla_equipo").append(trE)
        transporte()
    }


    function calculaHerramientas(){
        var h2 = $("#i_2868")
        var h3 = $("#i_2870")
        var h5 = $("#i_2869")
        var h
        if(h2.html())
            h=h2
        if(h3.html())
            h=h3
        if(h5.html())
            h=h5


        if(h){

            var precio = 0
            var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&ids="+ str_replace("i_","",h.attr("id"))
            $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPrecios')}",
                data     : datos,
                success  : function (msg) {
                    var precios = msg.split("&")

                    for(i=0;i<precios.length;i++){
                        var parts = precios[i].split(";")
//                        console.log(parts,parts.length)
                        if(parts.length>1){
                            precio = parseFloat(parts[1].trim())

                        }


                    }
                    var padre = h.parent()
                    var rend = padre.find(".rend")
                    var hora = padre.find(".col_hora")
                    var total= padre.find(".col_total")
                    var cant = padre.find(".cant")
                    var tarifa = padre.find(".col_tarifa")
                    rend.html(number_format(1, 5, ".", ""))
                    cant.html(number_format($("#total_mano").find(".valor_total").html(), 5, ".", ""))
                    tarifa.html(number_format(precio, 5, ".", ""))
                    hora.html(number_format(parseFloat(cant.html())*parseFloat(tarifa.html()), 5, ".", ""))
                    total.html(number_format(parseFloat(hora.html())*parseFloat(rend.html()), 5, ".", ""))

                }
            });


        }
        totalEquipos()
    }


    function calcularTotales(){
        var materiales = $("#tabla_material").children()
        var equipos = $("#tabla_equipo").children()
        var manos = $("#tabla_mano").children()
        var totalM= 0,totalE= 0,totalMa=0
        var trM=$("<tr id='total_material' class='total'>")
        var trMa=$("<tr id='total_mano' class='total'>")
        var trE=$("<tr id='total_equipo' class='total'>")

        var td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trM.append(td)
        td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trMa.append(td)
        td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trE.append(td)
        for(i=0;i<5;i++){
            td=$("<td>")
            trM.append(td)
            td=$("<td>")
            trMa.append(td)
            td=$("<td>")
            trE.append(td)
        }

        materiales.each(function(){
            totalM+=parseFloat($(this).find(".col_total").html())
        })
        manos.each(function(){
            totalMa+=parseFloat($(this).find(".col_total").html())
        })
        td=$("<td class='valor_total' style='text-align: right;font-weight: bold'>")
        td.html(number_format(totalM, 5, ".", ""))
        trM.append(td)
        td=$("<td class='valor_total'  style='text-align: right;font-weight: bold'>")
        td.html(number_format(totalMa, 5, ".", ""))
        trMa.append(td)
        $("#tabla_material").append(trM)
        $("#tabla_mano").append(trMa)
        calculaHerramientas()
//        window.setTimeout(vacio,2000)
//
//        equipos.each(function(){
//            totalE+=parseFloat($(this).find(".col_total").html())
//        })
//
//        td=$("<td class='valor_total'  style='text-align: right;;font-weight: bold'>")
//        td.html(number_format(totalE, 5, ".", ""))
//        trE.append(td)


//        $("#tabla_equipo").append(trE)


    }

    function tablaIndirectos(){
        var total=0
        $(".valor_total").each(function(){
            total+=$(this).html()*1
        })
        var indi = $("#costo_indi").val()
        if(isNaN(indi))
            indi=21.5
        indi=parseFloat(indi)
        var tabla = $('<table class="table table-bordered table-striped table-condensed table-hover">')
        tabla.append("<thead><tr><th colspan='3'>Costos indirectos</th></tr><tr><th style='width: 885px;'>Descripción</th><th style='text-align: right'>Porcentaje</th><th style='text-align: right'>Valor</th></tr></thead>")
        tabla.append("<tbody><tr><td>Costos indirectos</td><td style='text-align: right'>"+indi+"%</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100, 5, ".", "")+"</td></tr></tbody>")
        tabla.append("</table>")
        $("#tabla_indi").append(tabla)
        tabla = $('<table class="table table-bordered table-striped table-condensed table-hover" style="width: 360px;float: right;border: 1px solid #FFAC37">')
        tabla.append("<tbody>");
        tabla.append("<tr><td style='width: 300px;font-weight: bolder;'>Costo unitario directo</td><td style='text-align: right;font-weight: bold'>"+number_format(total, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Costos indirectos</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Costos total del rubro</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100+total, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Precio unitario</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100+total, 2, ".", "")+"</td></tr>")
        tabla.append("</tbody>");
        $("#tabla_costos").append(tabla)
        $("#tabla_costos").show("slide")
    }

    $(function () {

        <g:if test="${!rubro?.departamento?.subgrupo?.grupo?.id}">
        $("#selClase").val("");
        </g:if>
        $("#costo_indi").blur(function(){
            var indi = $(this).val()
            if(isNaN(indi) || indi*1<0){
                $.box({
                    imageClass : "box_info",
                    text       : "El porcentaje de costos indirectos debe ser un número positvo",
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        },
                        width     : 500
                    }
                });
                $("#costo_indi").val("21.5")
            }
        });

        $("#imprimir").click(function(){
            var dsps=$("#dist_peso").val()
            var dsvs=$("#dist_vol").val()
            var volqueta=$("#costo_volqueta").val()
            var chofer=$("#costo_chofer").val()
            %{--var datos = "?dsps="+dsps+"&dsvs="+dsvs+"&prvl="+volqueta+"&prch="+chofer+"&fecha="+$("#fecha_precios").val()+"&id=${rubro?.id}&lugar="+$("#ciudad").val()--}%
            %{--location.href="${g.createLink(controller: 'reportes3',action: 'imprimirRubro')}"+datos--}%
            var datos = "?dsps="+dsps+"Wdsvs="+dsvs+"Wprvl="+volqueta+"Wprch="+chofer+"Wfecha="+$("#fecha_precios").val()+"Wid=${rubro?.id}Wlugar="+$("#ciudad").val()+"Windi="+$("#costo_indi").val()
            var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubro')}"+datos
            location.href="${g.createLink(controller: 'pdf',action: 'pdfLink')}?url="+url
        });

        $("#transporte").click(function(){
            if ($("#fecha_precios").val().length < 8) {
                $.box({
                    imageClass : "box_info",
                    text       : "Seleccione una fecha para determinar la lista de precios",
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        },
                        width     : 500
                    }
                });
                $(this).removeClass("active")
            }else{
                $("#modal-transporte").modal("show");
            }
        })

        $("#cmb_vol").change(function(){
            if($("#cmb_vol").val()!="-1"){
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&ids="+$("#cmb_vol").val()
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&")

                        for(i=0;i<precios.length;i++){
                            var parts = precios[i].split(";")
//                        console.log(parts,parts.length)
                            if(parts.length>1)
                                $("#costo_volqueta").val(parts[1].trim())


                        }
                    }
                });
            }else{
                $("#costo_volqueta").val("0.00")
            }

        })
        $("#cmb_vol").change()
        $("#cmb_chof").change(function(){
            if($("#cmb_chof").val()!="-1"){
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val()  + "&ids="+$("#cmb_chof").val()
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&")
                        for(i=0;i<precios.length;i++){
                            var parts = precios[i].split(";")
                            if(parts.length>1)
                                $("#costo_chofer").val(parts[1].trim())


                        }
                    }
                });
            }else{
                $("#costo_chofer").val("0.00")
            }

        })
        $("#cmb_chof").change()

        $(".item_row").dblclick(function(){
            var hijos = $(this).children()
            var desc=$(hijos[1]).html()
            var cant
            var codigo=$(hijos[0]).html()
            var unidad
            var rendimiento
            var item
            for(i=2;i<hijos.length;i++){

                if($(hijos[i]).hasClass("cant"))
                    cant=$(hijos[i]).html()
                if($(hijos[i]).hasClass("col_unidad"))
                    unidad=$(hijos[i]).html()
                if($(hijos[i]).hasClass("col_rend"))
                    rendimiento=$(hijos[i]).html()
                if($(hijos[i]).hasClass("col_tarifa"))
                    item=$(hijos[i]).attr("id")
                if($(hijos[i]).hasClass("col_precioUnit"))
                    item=$(hijos[i]).attr("id")
                if($(hijos[i]).hasClass("col_jornal"))
                    item=$(hijos[i]).attr("id")

            }
            item=item.replace("i_","")
//            $("#item_cantidad").val(1.22852)
            $("#item_cantidad").val(cant.toString().trim())

//            console.log(item)
            if(rendimiento)
                $("#item_rendimiento").val(rendimiento.toString().trim())
            $("#item_id").val(item)
            $("#cdgo_buscar").val(codigo)
            $("#item_desc").val(desc)
            $("#item_unidad").val(unidad)



        })

        $("#selClase").change(function () {
            var clase = $(this).val();
            var $subgrupo = $("<select id='selSubgrupo' class='span12'></select>");
            $("#selSubgrupo").replaceWith($subgrupo);
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'gruposPorClase')}",
                data    : {
                    id : clase
                },
                success : function (msg) {
                    $("#selGrupo").replaceWith(msg);
                }
            });
        });
        $("#selGrupo").change(function () {
            var grupo = $(this).val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'subgruposPorGrupo')}",
                data    : {
                    id : grupo
                },
                success : function (msg) {
                    $("#selSubgrupo").replaceWith(msg);
                }
            });
        });

        $(".tipoPrecio").click(function () {
            if (!$(this).hasClass("active")) {
                var tipo = $(this).attr("id");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'ciudadesPorTipo')}",
                    data    : {
                        id : tipo
                    },
                    success : function (msg) {
                        $("#ciudad").replaceWith(msg);
                    }
                });
            }
        });

        $("#calcular").click(function () {
            if ($(this).hasClass("active")) {
                $(this).removeClass("active")
                $(".col_delete").show()
                $(".col_unidad").show()
                $(".col_tarifa").hide()
                $(".col_hora").hide()
                $(".col_total").hide()
                $(".col_jornal").hide()
                $(".col_precioUnit").hide()
                $(".col_vacio").hide()
                $(".total").remove()
                $("#tabla_indi").html("")
                $("#tabla_costos").html("")
                $("#tabla_transporte").html("")
            } else {
                $(this).addClass("active")
                var fecha = $("#fecha_precios").val()
                if (fecha.length < 8) {
                    $.box({
                        imageClass : "box_info",
                        text       : "Seleccione una fecha para determinar la lista de precios",
                        title      : "Alerta",
                        iconClose  : false,
                        dialog     : {
                            resizable : false,
                            draggable : false,
                            buttons   : {
                                "Aceptar" : function () {
                                }
                            },
                            width     : 500
                        }
                    });
                    $(this).removeClass("active")
                } else {
                    var items = $(".item_row")
                    if (items.size() < 1) {
                        $.box({
                            imageClass : "box_info",
                            text       : "Añada items a la composición del rubro antes de calcular los precios",
                            title      : "Alerta",
                            iconClose  : false,
                            dialog     : {
                                resizable : false,
                                draggable : false,
                                buttons   : {
                                    "Aceptar" : function () {
                                    }
                                },
                                width     : 500
                            }
                        });
                        $(this).removeClass("active")
                    } else {
                        var tipo = "C"
                        if ($("#V").hasClass("active"))
                            tipo = "V"
                        var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&tipo=" + tipo + "&ids="
                        $.each(items, function () {
                            datos += $(this).attr("id") + "#"
                        });

                        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPrecios')}",
                            data     : datos,
                            success  : function (msg) {
                                var precios = msg.split("&")
                                for(i=0;i<precios.length;i++){
                                    var parts = precios[i].split(";")
                                    var celda =$("#i_"+parts[0])
                                    celda.html(number_format(parts[1], 5, ".", ""))
                                    var padre = celda.parent()
//                                    console.log(parts,padre)
                                    var celdaRend = padre.find(".col_rend")
                                    var celdaTotal = padre.find(".col_total")
                                    var celdaCant = padre.find(".cant")
                                    var celdaHora =  padre.find(".col_hora")
//                                    console.log(celdaHora)
//                                    console.log(,,"rend "+celdaRend.html(),"total "+ celdaTotal.html(),"multi "+parseFloat(celda.html())*parseFloat(celdaCant.html()))
//                                    console.log("----")
//                                    console.log("celda "+parseFloat(celda.html()))
//                                    console.log("cant sin mun "+celdaCant.html() )
//                                    console.log("cant "+parseFloat(celdaCant.html()) )
//                                    console.log(" multi "+parseFloat(celda.html())*parseFloat(celdaCant.html()))
                                    var rend = 1
                                    if(celdaHora.hasClass("col_hora")){
                                        celdaHora.html(number_format(parseFloat(celda.html())*parseFloat(celdaCant.html()), 5, ".", ""))
                                    }
                                    if(celdaRend.html()){
                                        rend=celdaRend.html()*1
                                    }
                                    celdaTotal.html(number_format(parseFloat(celda.html())*parseFloat(celdaCant.html())*parseFloat(rend), 5, ".", ""))

                                }
                                calcularTotales()

                            }
                        });

                        $(".col_delete").hide()
                        $(".col_unidad").hide()
                        $(".col_tarifa").show()
                        $(".col_hora").show()
                        $(".col_total").show()
                        $(".col_jornal").show()
                        $(".col_precioUnit").show()
                        $(".col_vacio").show()
                    }
                }
            }
        });

        $("#btn_copiarComp").click(function () {
            if ($("#rubro__id").val() * 1 > 0) {
                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                $("#modalTitle").html("Lista de rubros");
                $("#modalFooter").html("").append(btnOk);
                $(".contenidoBuscador").html("")
                $("#modal-rubro").modal("show");
                $("#buscarDialog").unbind("click")
                $("#buscarDialog").bind("click", enviarCopiar)
            } else {
                $.box({
                    imageClass : "box_info",
                    text       : "Primero guarde el rubro o seleccione uno para editar",
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        },
                        width     : 500
                    }
                });
            }

        });

        $(".borrarItem").click(function () {
            var tr = $(this).parent().parent()
            if (confirm("Esta seguro de eliminar este registro? Esta acción es irreversible")) {
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'eliminarRubroDetalle')}",
                    data     : "id=" + $(this).attr("iden"),
                    success  : function (msg) {
                        if (msg == "Registro eliminado") {
                            tr.remove()
                        }

                        $.box({
                            imageClass : "box_info",
                            text       : msg,
                            title      : "Alerta",
                            iconClose  : false,
                            dialog     : {
                                resizable : false,
                                draggable : false,
                                buttons   : {
                                    "Aceptar" : function () {
                                    }
                                }
                            }
                        });

                    }
                });
            }

        });

        $("#cdgo_buscar").focus(function () {
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle").html("Lista de items");
            $("#modalFooter").html("").append(btnOk);
            $(".contenidoBuscador").html("")
            $("#modal-rubro").modal("show");
            $("#buscarDialog").unbind("click")
            $("#buscarDialog").bind("click", enviarItem)
        });
        $("#btn_lista").click(function () {

            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle").html("Lista de rubros");
//        $("#modalBody").html($("#buscador_rubro").html());
            $("#modalFooter").html("").append(btnOk);
            $(".contenidoBuscador").html("")
            $("#modal-rubro").modal("show");
            $("#buscarDialog").unbind("click")
            $("#buscarDialog").bind("click", enviar)

        }); //click btn new
        $("#rubro_registro").click(function () {
            if ($(this).hasClass("active")) {
                if (confirm("Esta seguro de desregistrar este rubro?")) {
                    $("#registrado").val("N")
                    $("#fechaReg").val("")
                }
            } else {
                if (confirm("Esta seguro de registrar este rubro?")) {
                    $("#registrado").val("R")
                    var fecha = new Date()
                    $("#fechaReg").val(fecha.toString("dd/mm/yyyy"))
                }
            }
        });

        $("#guardar").click(function () {
            $(".frmRubro").submit()
        });

        <g:if test="${rubro}">
        $("#btn_agregarItem").click(function () {
            if ($("#calcular").hasClass("active")){
                $.box({
                    imageClass : "box_info",
                    text       : "Antes de agregar items, por fvor desactive la opción calcular precios en el menú superior.",
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        }
                    }
                });
                return false
            }
            var cant = $("#item_cantidad").val()
            if (cant == "")
                cant = 0
            if (isNaN(cant))
                cant = 0
            var rend = $("#item_rendimiento").val()
            if (isNaN(rend))
                rend = 1
            if ($("#item_id").val() * 1 > 0) {
                if (cant > 0) {
                    var data = "rubro=${rubro.id}&item=" + $("#item_id").val() + "&cantidad=" + cant + "&rendimiento=" + rend
                    $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'addItem')}",
                        data     : data,
                        success  : function (msg) {
                            var tr = $("<tr class='item_row'>")
                            var td = $("<td>")
                            var band = true
                            var parts = msg.split(";")
                            tr.attr("id", parts[1])
                            var a
                            td.html($("#cdgo_buscar").val())
                            tr.append(td)
                            td = $("<td>")
                            td.html($("#item_desc").val())
                            tr.append(td)

                            if (parts[0] == "1") {
                                $("#tabla_material").children().find(".cdgo").each(function () {
                                    if ($(this).html() == $("#cdgo_buscar").val()) {
                                        var tdCant = $(this).parent().find(".cant")
                                        var tdRend = $(this).parent().find(".rend")
                                        tdCant.html(number_format(parts[3], 5, ".", ""))
                                        tdRend.html(number_format(parts[4], 5, ".", ""))
                                        band = false
                                    }
                                });
                                if (band) {
                                    td = $("<td style='text-align: center' class='col_unidad'>")
                                    td.html($("#item_unidad").val())
                                    tr.append(td)
                                    td = $("<td style='text-align: right' class='cant'>")
                                    td.html(number_format($("#item_cantidad").val(), 5, ".", ""))
                                    tr.append(td)
                                    td = $('<td class="col_precioUnit" style="display: none;text-align: right"></td>');
                                    td.attr("id","i_"+parts[2])
                                    tr.append(td)
                                    td = $('<td class="col_vacio" style="width: 40px;display: none"></td>');
                                    tr.append(td)
                                    td = $('<td class="col_vacio" style="width: 40px;display: none"></td>');
                                    tr.append(td)
                                    td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                                    tr.append(td)
                                    td = $('<td  style="width: 40px;text-align: center" class="col_delete">')
                                    a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>')
                                    td.append(a)
                                    tr.append(td)
                                    $("#tabla_material").append(tr)
                                }

                            } else {
                                if (parts[0] == "2") {

                                    $("#tabla_mano").children().find(".cdgo").each(function () {
                                        if ($(this).html() == $("#cdgo_buscar").val()) {
                                            var tdCant = $(this).parent().find(".cant")
                                            var tdRend = $(this).parent().find(".rend")
                                            tdCant.html(number_format(parts[3], 5, ".", ""))
                                            tdRend.html(number_format(parts[4], 5, ".", ""))
                                            band = false
                                        }
                                    });
                                    if (band) {
                                        td = $("<td style='text-align: right' class='cant'>")
                                        td.html(number_format(parts[3], 5, ".", ""))
                                        tr.append(td)
                                        td = $('<td class="col_jornal" style="display: none;text-align: right"></td>');
                                        td.attr("id","i_"+parts[2])
                                        tr.append(td)
                                        td = $('<td class="col_hora" style="display: none;text-align: right"></td>');
                                        tr.append(td)
                                        td = $("<td style='text-align: right' class='col_rend rend'>")
                                        td.html(number_format(parts[4], 5, ".", ""))
                                        tr.append(td)
                                        td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                                        tr.append(td)
                                        td = $('<td  style="width: 40px;text-align: center" class="col_delete">')
                                        a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>')
                                        td.append(a)
                                        tr.append(td)
                                        $("#tabla_mano").append(tr)
                                    }

                                } else {
                                    $("#tabla_equipo").children().find(".cdgo").each(function () {
                                        if ($(this).html() == $("#cdgo_buscar").val()) {

                                            var tdCant = $(this).parent().find(".cant")
                                            var tdRend = $(this).parent().find(".rend")
                                            tdCant.html(number_format(parts[3], 5, ".", ""))
                                            tdRend.html(number_format(parts[4], 5, ".", ""))

                                            band = false
                                        }
                                    });

                                    if (band) {
                                        td = $("<td style='text-align: right' class='cant'>")
                                        td.html(number_format(parts[3], 5, ".", ""))
                                        tr.append(td)
                                        td = $('<td class="col_tarifa" style="display: none;text-align: right"></td>');
                                        td.attr("id","i_"+parts[2])
                                        tr.append(td)
                                        td = $('<td class="col_hora" style="display: none;text-align: right"></td>');
                                        tr.append(td)
                                        td = $("<td style='text-align: right' class='col_rend rend'>")
                                        td.html(number_format(parts[4], 5, ".", ""))
                                        tr.append(td)
                                        td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                                        tr.append(td)
                                        td = $('<td  style="width: 40px;text-align: center" class="col_delete">')
                                        a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>')
                                        td.append(a)
                                        tr.append(td)
                                        $("#tabla_equipo").append(tr)
                                    }
                                }
                            }
                            if (a) {
                                a.bind("click", function () {
                                    var tr = $(this).parent().parent()
                                    if (confirm("Esta seguro de eliminar este registro? Esta acción es irreversible")) {
                                        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'eliminarRubroDetalle')}",
                                            data     : "id=" + $(this).attr("iden"),
                                            success  : function (msg) {
                                                if (msg == "Registro eliminado") {
                                                    tr.remove()
                                                }

                                                $.box({
                                                    imageClass : "box_info",
                                                    text       : msg,
                                                    title      : "Alerta",
                                                    iconClose  : false,
                                                    dialog     : {
                                                        resizable : false,
                                                        draggable : false,
                                                        buttons   : {
                                                            "Aceptar" : function () {
                                                            }
                                                        }
                                                    }
                                                });

                                            }
                                        });
                                    }

                                });
                            }

                            $("#item_desc").val("")
                            $("#item_id").val("")
                            $("#item_cantidad").val("1")
                            $("#cdgo_buscar").val("")
                            $("#cdgo_unidad").val("")
                            $("#item_rendimiento").val("1")
                        }
                    });
                } else {
                    $.box({
                        imageClass : "box_info",
                        text       : "La cantidad debe ser un número positivo",
                        title      : "Alerta",
                        iconClose  : false,
                        dialog     : {
                            resizable : false,
                            draggable : false,
                            buttons   : {
                                "Aceptar" : function () {
                                }
                            }
                        }
                    });
                }
            } else {
                $.box({
                    imageClass : "box_info",
                    text       : "Seleccione un item",
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        }
                    }
                });
            }
        });
        </g:if>
        <g:else>
        $("#btn_agregarItem").click(function () {
            $.box({
                imageClass : "box_info",
                text       : "Primero guarde el rubro o seleccione uno para editar",
                title      : "Alerta",
                iconClose  : false,
                dialog     : {
                    resizable : false,
                    draggable : false,
                    buttons   : {
                        "Aceptar" : function () {
                        }
                    },
                    width     : 500
                }
            });

        });
        </g:else>
    });
</script>

</body>
</html>
