
<%@ page import="janus.Indice" %>

<div id="create-Indice" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-Indice" action="save">
        <g:hiddenField name="id" value="${indiceInstance?.id}"/>
                
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Tipo Indice
                </span>
            </div>

            <div class="controls">
                <g:select id="tipoIndice" name="tipoIndice.id" from="${janus.TipoIndice.list()}" optionKey="id" class="many-to-one " value="${indiceInstance?.tipoIndice?.id}" noSelection="['null': '']"/>
                
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
                
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Codigo
                </span>
            </div>

            <div class="controls">
                <g:textField name="codigo" maxlength="20" class="" value="${indiceInstance?.codigo}"/>
                
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
                
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Descripcion
                </span>
            </div>

            <div class="controls">
                <g:textField name="descripcion" maxlength="131" class=" required" value="${indiceInstance?.descripcion}"/>
                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
                
    </g:form>

<script type="text/javascript">
    $("#frmSave-Indice").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function(form) {
            $(".btn-success").replaceWith(spinner);
            form.submit();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>
