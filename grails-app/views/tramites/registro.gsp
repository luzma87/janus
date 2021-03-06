<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 4/29/13
  Time: 11:54 AM
  To change this template use File | Settings | File Templates.
--%>


<%@ page import="janus.Tramite" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Registro de Trámites
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>
    </head>

    <body>

        <g:if test="${flash.message}">
            <div class="row">
                <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                    <a class="close" data-dismiss="alert" href="#">×</a>
                    ${flash.message}
                </div>
            </div>
        </g:if>

        <div class="row btn-group" role="navigation">
            <a href="#" class="btn btn-ajax btn-new" id="btnSave">
                <i class="icon-save"></i>
                Guardar
            </a>
        </div>

        <div id="registra-tramite" class="span12" role="main" style="margin-top: 10px;">
            <g:form class="form-horizontal" name="frmRegistrar-tramite" action="registrar2">
                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Tipo
                        </span>
                    </div>

                    <div class="controls">
                        <elm:select id="tipoTramite" name="tipoTramite.id" from="${janus.TipoTramite.list([sort: 'descripcion'])}"
                                    optionKey="id" optionClass="tipo"
                                    class="many-to-one required" noSelection="['': '']"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div id="personas"></div>

                <div class="control-group hide" id="grupoTipo">
                    <div>
                        <span class="control-label label label-inverse" id="lblTipo">
                            Obra
                        </span>
                    </div>

                    <div class="controls">
                        <g:textField name="txtTipo" class=" required span6"/>
                        <g:hiddenField name="hddTipo"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Asunto
                        </span>
                    </div>

                    <div class="controls">
                        <g:textArea name="descripcion" class="span6 required"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Fecha creación
                        </span>
                    </div>

                    <div class="controls">
                        <elm:datepicker name="fecha" class=" required"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            N<sup>o</sup> Memo S.A.D.
                        </span>
                    </div>

                    <div class="controls">
                        <g:textField name="memo" class="required"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Docs. adjuntos
                        </span>
                    </div>

                    <div class="controls">
                        <g:textArea name="documentosAdjuntos" class="span6"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>
            </g:form>
        </div>


        <div class="modal grandote hide fade " id="modal-busca" style=";overflow: hidden;">
            <div class="modal-header btn-info">
                <button type="button" class="close" data-dismiss="modal">×</button>

                <h3 id="modalTitle-busca"></h3>
            </div>

            <div class="modal-body" id="modalBody-busca">
                <bsc:buscador name="obra" value="" accion="buscaObra" campos="${campos}" label="Obra" tipo="lista"/>
            </div>

            <div class="modal-footer" id="modalFooter-busca">
            </div>
        </div>



        <script type="text/javascript">
            var $tipoTramite = $("#tipoTramite");

            function buscarContrato() {
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
                $.ajax({type : "POST", url : "${g.createLink(action:'buscaContrato')}",
                    data     : data,
                    success  : function (msg) {
                        $("#spinner").hide();
                        $("#buscarDialog").show();
                        $(".contenidoBuscador").html(msg).show("slide");
                    }
                });
            }

            function getPersonas(box, cur) {
                $("#lblTipo").html(lblTipo);
                var val = box.val();
                if (val != cur) {
                    cur = val;
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'personasPorTipo')}",
                        data    : {
                            tipo : cur
                        },
                        success : function (msg) {
                            if (msg != "") {
                                $("#personas").html(msg);
                                $("#grupoTipo").show();
                            } else {
                                $("#grupoTipo").hide();
                                $("#personas").html("<div class='row'><div class='alert alert-danger span7'>El tipo de trámite no ha sido configurado. Por favor seleccione otro.</div></div>");
                            }
                        }
                    });
                }
            }

            $(function () {
                $tipoTramite.val("");
                var cur = $tipoTramite.val();

                $('[rel=tooltip]').tooltip();

                $("#frmRegistrar-tramite").validate();

                $("#btnSave").click(function () {
                    if ($("#frmRegistrar-tramite").valid()) {
                        $("#btnSave").replaceWith(spinner);
                        $("#frmRegistrar-tramite").submit();
                    }
                });

                $tipoTramite.bind("keyup change", function () {
                    var box = $(this);
                    var tipo = $("#tipoTramite option:selected").attr("class");
                    $("#buscarDialog").unbind("click");
                    if (tipo == "C") {
                        lblTipo = "Contrato";
                        $("#modalTitle-busca").html("Lista de contratos");
                        $("#buscarDialog").bind("click", buscarContrato);
                        getPersonas(box, cur);
                    } else if (tipo == "O") {
                        lblTipo = "Obra";
                        $("#modalTitle-busca").html("Lista de obras");
                        $("#buscarDialog").bind("click", enviar);
                        getPersonas(box, cur);
                    }
                });

                $("#txtTipo").click(function () {
                    if ($("#tipoTramite").val() != "") {
                        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                        $("#modalFooter-busca").html("").append(btnOk);
                        $(".contenidoBuscador").html("");
                        $("#modal-busca").modal("show");
                    }
                });
            });

        </script>

    </body>
</html>
