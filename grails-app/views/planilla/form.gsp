<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 2/7/13
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            <g:if test="${planillaInstance.id}">
                Editar planilla
            </g:if>
            <g:else>
                Nueva Planilla
            </g:else>
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>

        <style type="text/css">
        .formato {
            font-weight : bolder;
        }

        select.label-important, textarea.label-important {
            background  : none !important;
            color       : #555 !important;
            text-shadow : none !important;
        }
        </style>
    </head>

    <body>

        <div class="btn-toolbar" style="margin-bottom: 20px;">
            <div class="btn-group">
                <g:link action="list" id="${contrato.id}" class="btn">
                    <i class="icon-arrow-left"></i>
                    Cancelar
                </g:link>

                <g:link action="form" class="btn" params="[contrato: contrato.id]">
                    <i class="icon-file"></i>
                    Nueva planilla
                </g:link>

                <a href="#" id="btnSave" class="btn btn-success">
                    <i class="icon-save"></i>
                    Guardar
                </a>
            </div>
        </div>

        <g:if test="${flash.message}">
            <div class="row">
                <div class="span12">
                    <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </div>
            </div>
        </g:if>

        <g:form name="frmSave-Planilla" action="save">
            <fieldset>
                <g:hiddenField name="id" value="${planillaInstance?.id}"/>
                <g:hiddenField id="contrato" name="contrato.id" value="${planillaInstance?.contrato?.id}"/>
                <g:hiddenField name="numero" value="${fieldValue(bean: planillaInstance, field: 'numero')}"/>

                <div class="row">
                    <div class='span2 formato'>
                        Tipo de Planilla
                    </div>

                    <div class="span4">
                        <g:select id="tipoPlanilla" name="tipoPlanilla.id" from="${tipos}" optionKey="id" optionValue="nombre" class="many-to-one span3 required" value="${planillaInstance?.tipoPlanilla?.id}" noSelection="['': '']"/>
                        <span class="mandatory">*</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                    <div class="span2 formato periodo hide">
                        Periodo
                    </div>

                    <div class="span4 periodo hide">
                        <g:select id="periodoIndices" name="periodoIndices.id" from="${periodos}" optionKey="id" class="many-to-one span3"
                                  value="${planillaInstance?.periodoIndices?.id}" noSelection="['': '']" optionValue="descripcion"/>
                        <span class="mandatory">*</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">

                    <div class="span2 formato">
                        Número planilla
                    </div>

                    <div class="span4">
                        %{--<g:field type="number" name="numero" class=" required" value="${fieldValue(bean: planillaInstance, field: 'numero')}"/>--}%
                        <span class="uneditable-input span3">${planillaInstance.numero}</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                    <div class="span2 formato">
                        Número Factura
                    </div>

                    <div class="span4">
                        <g:textField name="numeroFactura" maxlength="15" class=" span3" value="${planillaInstance?.numeroFactura}"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">
                    <div class="span2 formato">
                        Fecha Presentacion
                    </div>

                    <div class="span4">
                        <elm:datepicker name="fechaPresentacion" class=" span3 required" value="${planillaInstance?.fechaPresentacion}"/>
                        <span class="mandatory">*</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                    <div class="span2 formato">
                        Fecha Ingreso
                    </div>

                    <div class="span4">
                        <elm:datepicker name="fechaIngreso" class=" span3 required" value="${planillaInstance?.fechaIngreso}"/>
                        <span class="mandatory">*</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">
                    <div class="span2 formato">
                        Descripción
                    </div>

                    <div class="span10">
                        <g:textArea name="descripcion" cols="40" rows="2" maxlength="254" class="span9 required" value="${planillaInstance?.descripcion}" style="resize: none;"/>
                        <span class="mandatory">*</span>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">
                    <div class="span2 formato">
                        Oficio Salida
                    </div>

                    <div class="span4">
                        <g:textField name="oficioSalida" maxlength="12" class=" span3 " value="${planillaInstance?.oficioSalida}"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                    <div class="span2 formato">
                        Fecha Oficio Salida
                    </div>

                    <div class="span4">
                        <elm:datepicker name="fechaOficioSalida" class=" span3" value="${planillaInstance?.fechaOficioSalida}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">
                    <div class="span2 formato">
                        Memo Salida
                    </div>

                    <div class="span4">
                        <g:textField name="memoSalida" maxlength="12" class=" span3" value="${planillaInstance?.memoSalida}"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                    <div class="span2 formato">
                        Fecha Memo Salida
                    </div>

                    <div class="span4">
                        <elm:datepicker name="fechaMemoSalida" class=" span3" value="${planillaInstance?.fechaMemoSalida}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="row">
                    <div class="span2 formato">
                        Observaciones
                    </div>

                    <div class="span10">
                        <g:textField name="observaciones" maxlength="127" class="span9" value="${planillaInstance?.observaciones}"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>

                </div>

            </fieldset>
        </g:form>


        <script type="text/javascript">

            function checkPeriodo() {
                if ($("#tipoPlanilla").val() == "3") {
                    $(".periodo").show();
                } else {
                    $(".periodo").hide();
                }
            }

            $(function () {
                checkPeriodo();

                $("#frmSave-Planilla").validate({
                    errorPlacement : function (error, element) {
                        element.parent().find(".help-block").html(error).show();
                    },
                    errorClass     : "label label-important"
                });

                $("#btnSave").click(function () {
                    $("#frmSave-Planilla").submit();
                });

                $("#tipoPlanilla").change(function () {
                    checkPeriodo();
                });
            });

        </script>

    </body>
</html>