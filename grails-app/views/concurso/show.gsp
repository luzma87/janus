<%@ page import="janus.pac.Concurso" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Concurso
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins', file: 'jquery.livequery.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.ui.position.js')}" type="text/javascript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.js')}" type="text/javascript"></script>
        <link href="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.css')}" rel="stylesheet" type="text/css"/>
        <style>
        td {
            line-height : 12px !important;
        }
        </style>
    </head>

    <body>
        <div class="span12 btn-group" role="navigation">

            <div class="row">
                <div class="span9 btn-group" role="navigation">
                    <g:link controller="concurso" action="list" class="btn">
                        <i class="icon-angle-left"></i> Regresar
                    </g:link>

                    <a href="#" class="btn  " id="registrar" style="${(concursoInstance.estado == "R") ? 'display: none' : ''}">
                        <i class="icon-check"></i>
                        Registrar
                    </a>
                    <g:if test="${of == 0}">
                        <a href="#" class="btn  " id="desregistrar" style="${(concursoInstance.estado != "R") ? 'display: none' : ''}">
                            <i class="icon-edit"></i>
                            Desregistrar
                        </a>
                    </g:if>
                </div>
            </div>

            <div id="list-grupo" class="span12" role="main" style="margin-top: 10px;margin-left: -10px">

                <form class="form-horizontal">

                    <g:if test="${concursoInstance?.obra}">
                        <div class="control-group">
                            <div>
                                <span id="obra-label" class="control-label label label-inverse">
                                    Obra
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="obra-label">
                                    %{--<g:link controller="obra" action="show" id="${concursoInstance?.obra?.id}">--}%
                                    ${concursoInstance?.obra?.descripcion}
                                    %{--</g:link>--}%
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.administracion}">
                        <div class="control-group">
                            <div>
                                <span id="administracion-label" class="control-label label label-inverse">
                                    Administracion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="administracion-label">
                                    %{--<g:link controller="administracion" action="show" id="${concursoInstance?.administracion?.id}">--}%
                                    ${concursoInstance?.administracion?.descripcion}
                                    %{--</g:link>--}%
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.pac}">
                        <div class="control-group">
                            <div>
                                <span id="pac-label" class="control-label label label-inverse">
                                    Pac
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="pac-label">
                                    %{--<g:link controller="pac" action="show" id="${concursoInstance?.pac?.id}">--}%
                                    ${concursoInstance?.pac?.descripcion}
                                    %{--</g:link>--}%
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.codigo}">
                        <div class="control-group">
                            <div>
                                <span id="codigo-label" class="control-label label label-inverse">
                                    Codigo
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="codigo-label">
                                    <g:fieldValue bean="${concursoInstance}" field="codigo"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.objeto}">
                        <div class="control-group">
                            <div>
                                <span id="objeto-label" class="control-label label label-inverse">
                                    Objeto
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="objeto-label">
                                    <g:fieldValue bean="${concursoInstance}" field="objeto"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.costoBases}">
                        <div class="control-group">
                            <div>
                                <span id="costoBases-label" class="control-label label label-inverse">
                                    Costo Bases
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="costoBases-label">
                                    <g:fieldValue bean="${concursoInstance}" field="costoBases"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaInicio}">
                        <div class="control-group">
                            <div>
                                <span id="fechaInicio-label" class="control-label label label-inverse">
                                    Fecha Inicio
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaInicio-label">
                                    <g:formatDate date="${concursoInstance?.fechaInicio}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaPublicacion}">
                        <div class="control-group">
                            <div>
                                <span id="fechaPublicacion-label" class="control-label label label-inverse">
                                    Fecha Publicacion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaPublicacion-label">
                                    <g:formatDate date="${concursoInstance?.fechaPublicacion}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaLimitePreguntas}">
                        <div class="control-group">
                            <div>
                                <span id="fechaLimitePreguntas-label" class="control-label label label-inverse">
                                    Fecha Limite Preguntas
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaLimitePreguntas-label">
                                    <g:formatDate date="${concursoInstance?.fechaLimitePreguntas}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaLimiteRespuestas}">
                        <div class="control-group">
                            <div>
                                <span id="fechaLimiteRespuestas-label" class="control-label label label-inverse">
                                    Fecha Limite Respuestas
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaLimiteRespuestas-label">
                                    <g:formatDate date="${concursoInstance?.fechaLimiteRespuestas}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaLimiteEntregaOfertas}">
                        <div class="control-group">
                            <div>
                                <span id="fechaLimiteEntregaOfertas-label" class="control-label label label-inverse">
                                    Fecha Limite Entrega Ofertas
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaLimiteEntregaOfertas-label">
                                    <g:formatDate date="${concursoInstance?.fechaLimiteEntregaOfertas}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaLimiteSolicitarConvalidacion}">
                        <div class="control-group">
                            <div>
                                <span id="fechaLimiteSolicitarConvalidacion-label" class="control-label label label-inverse">
                                    Fecha Limite Solicitar Convalidacion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaLimiteSolicitarConvalidacion-label">
                                    <g:formatDate date="${concursoInstance?.fechaLimiteSolicitarConvalidacion}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaLimiteRespuestaConvalidacion}">
                        <div class="control-group">
                            <div>
                                <span id="fechaLimiteRespuestaConvalidacion-label" class="control-label label label-inverse">
                                    Fecha Limite Respuesta Convalidacion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaLimiteRespuestaConvalidacion-label">
                                    <g:formatDate date="${concursoInstance?.fechaLimiteRespuestaConvalidacion}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaCalificacion}">
                        <div class="control-group">
                            <div>
                                <span id="fechaCalificacion-label" class="control-label label label-inverse">
                                    Fecha Calificacion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaCalificacion-label">
                                    <g:formatDate date="${concursoInstance?.fechaCalificacion}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaInicioPuja}">
                        <div class="control-group">
                            <div>
                                <span id="fechaInicioPuja-label" class="control-label label label-inverse">
                                    Fecha Inicio Puja
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaInicioPuja-label">
                                    <g:formatDate date="${concursoInstance?.fechaInicioPuja}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaFinPuja}">
                        <div class="control-group">
                            <div>
                                <span id="fechaFinPuja-label" class="control-label label label-inverse">
                                    Fecha Fin Puja
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaFinPuja-label">
                                    <g:formatDate date="${concursoInstance?.fechaFinPuja}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <g:if test="${concursoInstance?.fechaAdjudicacion}">
                        <div class="control-group">
                            <div>
                                <span id="fechaAdjudicacion-label" class="control-label label label-inverse">
                                    Fecha Adjudicacion
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="fechaAdjudicacion-label">
                                    <g:formatDate date="${concursoInstance?.fechaAdjudicacion}"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                    <div class="control-group">
                        <div>
                            <span id="estado-label" class="control-label label label-inverse">
                                Estado
                            </span>
                        </div>

                        <div class="controls">

                            <span aria-labelledby="estado-label" id="etdo">
                                ${(concursoInstance.estado == "R") ? "Registrado" : "No registrado"}
                            </span>

                        </div>
                    </div>


                    <g:if test="${concursoInstance?.observaciones}">
                        <div class="control-group">
                            <div>
                                <span id="observaciones-label" class="control-label label label-inverse">
                                    Observaciones
                                </span>
                            </div>

                            <div class="controls">

                                <span aria-labelledby="observaciones-label">
                                    <g:fieldValue bean="${concursoInstance}" field="observaciones"/>
                                </span>

                            </div>
                        </div>
                    </g:if>

                </form>
                <script type="text/javascript">
                    $("#registrar").click(function () {
                        if (confirm("Esta seguro")) {
                            $("#dlgLoad").dialog("open")
                            $.ajax({type : "POST", url : "${g.createLink(controller: 'concurso',action:'registrar')}",
                                data     : "id=${concursoInstance?.id}&estado=R",
                                success  : function (msg) {
                                    $("#dlgLoad").dialog("close")
                                    if (msg == "ok") {
                                        $("#desregistrar").show()
                                        $("#registrar").hide()
                                        $("#etdo").html("Registrado")
                                    }
                                }
                            });
                        }
                    })
                    $("#desregistrar").click(function () {
                        if (confirm("Esta seguro")) {
                            $("#dlgLoad").dialog("open")
                            $.ajax({type : "POST", url : "${g.createLink(controller: 'concurso',action:'registrar')}",
                                data     : "id=${concursoInstance?.id}&estado=D",
                                success  : function (msg) {
                                    $("#dlgLoad").dialog("close")
                                    if (msg == "ok") {
                                        $("#registrar").show()
                                        $("#desregistrar").hide()
                                        $("#etdo").html("No registrado")
                                    }
                                }
                            });
                        }

                    })
                </script>
            </div>
    </body>
</html>