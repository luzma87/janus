package janus.actas

import groovy.json.JsonBuilder
import janus.Contrato
import janus.NumberToLetterConverter
import org.springframework.dao.DataIntegrityViolationException

class ActaController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    private String fechaConFormato(fecha, formato) {
        def meses = ["", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        def mesesLargo = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        def strFecha = ""
//        println ">>" + fecha + "    " + formato
        if (fecha) {
            switch (formato) {
                case "MMM-yy":
                    strFecha = meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yy")
                    break;
                case "dd-MM-yyyy":
                    strFecha = "" + fecha.format("dd-MM-yyyy")
                    break;
                case "dd-MMM-yyyy":
                    strFecha = "" + fecha.format("dd") + "-" + meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yyyy")
                    break;
                case "dd MMMM yyyy":
                    strFecha = "" + fecha.format("dd") + " de " + mesesLargo[fecha.format("MM").toInteger()] + " de " + fecha.format("yyyy")
                    break;
                default:
                    strFecha = "Formato " + formato + " no reconocido"
                    break;
            }
        }
//        println ">>>>>>" + strFecha
        return strFecha
    }

    private String cap(str) {
        return str.replaceAll(/[a-zA-Z_0-9áéíóúÁÉÍÓÚñÑüÜ]+/, {
            it[0].toUpperCase() + ((it.size() > 1) ? it[1..-1].toLowerCase() : '')
        })
    }

    private String nombrePersona(persona, tipo) {
//        println persona
//        println tipo
        def str = ""
        if (persona) {
            switch (tipo) {
                case "pers":
                    str = cap((persona.titulo ? persona.titulo + " " : "") + persona.nombre + " " + persona.apellido)
                    break;
                case "prov":
                    str = cap((persona.titulo ? persona.titulo + " " : "") + persona.nombreContacto + " " + persona.apellidoContacto)
                    break;
            }
        }
//        println str
//        println "****************************************************"
        return str
    }

    private String numero(num, decimales, cero) {
        if (num == 0 && cero.toString().toLowerCase() == "hide") {
            return " ";
        }
        if (decimales == 0) {
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec")
        } else {
            def format
            if (decimales == 2) {
                format = "##,##0"
            } else if (decimales == 3) {
                format = "##,###0"
            }
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec", format: format)
        }
    }

    private String numero(num, decimales) {
        return numero(num, decimales, "show")
    }

    private String numero(num) {
        return numero(num, 3)
    }

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [actaInstanceList: Acta.list(params), params: params]
    } //list

    def form() {
        if (!params.tipo) {
            params.tipo = 'P' //provisional
        }

        def tipo = params.tipo.toUpperCase()

        if (tipo != 'D' && tipo != 'P') {
            flash.message = "No se reconoció el tipo de acta " + tipo
            redirect(action: "errores", params: [contrato: params.contrato])
            return
        }

//        def tipos = new Acta().constraints.tipo.inList
        def tipos = [params.tipo]

        def actaProv = null
        if (params.contrato || params.id) {
            def secciones = []
            def actaInstance = new Acta(params)
            if (params.id) {
                actaInstance = Acta.get(params.id.toLong())
                tipo = actaInstance.tipo
                if (!actaInstance) {
                    flash.clase = "alert-error"
                    flash.message = "No se encontró Acta con id " + params.id
                    redirect(action: "list")
                    return
                } //no existe el objeto

                def sec = actaInstance.secciones

                if (sec.size() == 0) {
                    def contrato = actaInstance.contrato
                    def obra = contrato.oferta.concurso.obra

                    if (tipo == 'P') {
                        secciones = [
                                [
                                        numero: 1,
                                        titulo: "ANTECEDENTES",
                                        parrafos: [
                                                [
                                                        numero: 1,
                                                        contenido: "La presente Acta se suscribe en atención a la solicitud formulada por el contratista el " + fechaConFormato(contrato.fechaPedidoRecepcionContratista, "dd MMMM yyyy") + " y tramitada mediante hoja de control y trámite N."
                                                ],
                                                [
                                                        numero: 2,
                                                        contenido: "En cumplimiento del artículo 81 de la Ley Orgánica del Sistema Nacional de Contratación Pública el señor Prefecto autoriza el trámite solicitado por el contratista medinte hoja de control y trámite N."
                                                ],
                                        ]
                                ],
                                [
                                        numero: 2,
                                        titulo: "CONDICIONES GENERALES DE EJECUCIÓN",
                                        parrafos: [
                                                [
                                                        numero: 1,
                                                        contenido: "Mediante contrato " + contrato.codigo + " suscrito el " + fechaConFormato(contrato.fechaSubscripcion, "dd-MM-yyyy") + " el contratista " +
                                                                "" + nombrePersona(contrato.oferta.proveedor, "prov") + " se compromete a construir <strong>" + contrato.objeto + "</strong> en " +
                                                                "<strong>" + obra.sitio + "</strong> - <strong>Parroquia " + obra.parroquia.nombre + " - Cantón " + obra.parroquia.canton.nombre + "</strong>" +
                                                                "<br/>Por un monto de \$ <strong>" + numero(contrato.monto, 2) + "</strong>" +
                                                                "<br/>Anticipo entregado \$ <strong>" + numero(contrato.anticipo, 2) + " (" + numero(contrato.porcentajeAnticipo, 0) + "%)</strong>"
                                                ]
                                        ]
                                ],
                                [
                                        numero: 3,
                                        titulo: "CONDICIONES OPERATIVAS"
                                ],
                                [
                                        numero: 4,
                                        titulo: "LIQUIDACIÓN ECONÓMICA",
                                        parrafos: [
                                                [
                                                        numero: 1,
                                                        contenido: "<strong>OBRA EJECUTADA.-</strong> Los rubros ejecutados y pagados en las planillas correspondientes son los siguientes",
                                                        tipoTabla: "RBR"
                                                ],
                                                [
                                                        numero: 2,
                                                        contenido: "<strong>DETALLE DE PLANILLAS.-</strong> Los rubros ejecutados por el contratista, medidos en la obra y aceptados por las partes, se hallan consignados en planillas de pago de acuerdo al siguiente detalle:",
                                                        tipoTabla: "DTP"
                                                ],
                                                [
                                                        numero: 3,
                                                        contenido: "<strong>DETALLE DE OBRAS ADICIONALES:</strong>",
                                                        tipoTabla: "OAD"
                                                ],
                                                [
                                                        numero: 4,
                                                        contenido: "<strong>RESUMEN DE OBRAS BAJO LA MODALIDAD COSTO + PORCENTAJE:</strong>",
                                                        tipoTabla: "OCP"
                                                ],
                                                [
                                                        numero: 5,
                                                        contenido: "<strong>RESUMEN DE REAJUSTES DE PRECIOS:</strong>",
                                                        tipoTabla: "RRP"
                                                ],
                                                [
                                                        numero: 6,
                                                        contenido: "<strong>RESUMEN GENERAL DE VALORES:</strong>",
                                                        tipoTabla: "RGV"
                                                ]
                                        ]
                                ],
                                [
                                        numero: 5,
                                        titulo: "LIQUIDACIÓN DE PLAZOS",
                                        parrafos: [
                                                [
                                                        numero: 1,
                                                        contenido: "El plazo de entrega de la obra, según el contrato, es de: <strong>" + numero(contrato.plazo, 0) + " días calendario</strong>" +
                                                                " contados a partir del " + fechaConFormato(obra.fechaInicio, "dd-MM-yyyy") + " según orden de inicio impartida por la Dirección de " +
                                                                "Fiscalización mediante "
                                                ]
                                        ]
                                ]
                        ]

                        secciones.each { s ->
                            def seccion = new Seccion([
                                    acta: actaInstance,
                                    numero: s.numero,
                                    titulo: s.titulo
                            ])
                            if (!seccion.save(flush: true)) {
                                println "error al guardar seccion " + s.numero + ": " + seccion.errors
                            } else {
                                s.id=seccion.id
                                s.parrafos.each { p ->
                                    def tipoTabla = null
                                    if (p.tipoTabla) {
                                        tipoTabla = p.tipoTabla
                                    }
                                    def parrafo = new Parrafo([
                                            seccion: seccion,
                                            numero: p.numero,
                                            contenido: p.contenido,
                                            tipoTabla: tipoTabla
                                    ])
                                    if (!parrafo.save(flush: true)) {
                                        println "error al guardar el parrafo (" + seccion.numero + ") " + p.numero + ": " + parrafo.errors
                                    } else {
                                        p.id=parrafo.id
                                    }
                                }
                            }
                        } //secciones.each para guardar
                    } // es provisional: se crean las secciones/parrafos por default
                    else if (tipo == 'D') {
//                        println "AQUIQQQQQ"
                        contrato = actaInstance.contrato
                        actaProv = Acta.findAllByContratoAndTipo(contrato, 'P')
                        if (actaProv.size() == 1) {
                            actaProv = actaProv[0]
//                            println actaProv
//                            println actaProv.fechaRegistro
//                            println actaProv.registrada
                            if (actaProv.fechaRegistro && actaProv.registrada == 1) {
//                                println "ASDFASDFASDF"
                                //secciones
                                actaProv.secciones.each { seccion ->
                                    def nuevaSec = new Seccion([
                                            numero: seccion.numero,
                                            titulo: seccion.titulo,
                                            acta: actaInstance
                                    ])
                                    if (nuevaSec.save(flush: true)) {
                                        seccion.parrafos.each { parrafo ->
                                            def nuevoParr = new Parrafo([
                                                    numero: parrafo.numero,
                                                    contenido: parrafo.contenido,
                                                    tipoTabla: parrafo.tipoTabla,
                                                    seccion: nuevaSec
                                            ])
                                            if (!nuevoParr.save(flush: true)) {
                                                println "error al guardar: " + nuevoParr.errors
                                            }
                                        }
                                    } else {
                                        println "error al guardar: " + nuevaSec.errors
                                    }
                                }
                                sec = Seccion.findAllByActa(actaInstance)
                            } else {
                                flash.message = "No ha registrado el acta provisional, no puede generar el acta definitiva."
                                redirect(action: "errores", params: [contrato: params.contrato])
                                return
                            }
                        }
                    } //es definitiva: se copian las secciones/parrafos de la provisional
//                    sec = actaInstance.secciones
                    sec = Seccion.findAllByActa(actaInstance)
//                    println sec
                }

                sec.each { s ->
                    def objSec = [:]
                    objSec.id = s.id
                    objSec.numero = s.numero
                    objSec.titulo = s.titulo
                    objSec.parrafos = []
                    Parrafo.findAllBySeccion(s).each { p ->
                        objSec.parrafos.add([
                                id: p.id,
                                numero: p.numero,
                                contenido: p.contenido,
                                tipoTabla: p.tipoTabla
                        ])
                    }
                    secciones.add(objSec)
                }
            } //es edit
            else {
                if (params.contrato) {
                    def sec = []
                    def contrato = Contrato.get(params.contrato)
                    def actas = Acta.findAllByContratoAndTipo(contrato, tipo)
                    if (actas.size() == 0) {

                        def meses = ['', "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
                        def hoy = new Date()
                        actaInstance.contrato = contrato
                        if (params.tipo == 'P') {
                            def obra = actaInstance.contrato.oferta.concurso.obra
                            actaInstance.descripcion = "En la parroquia <strong>" + obra.parroquia.nombre + "</strong>, cantón <strong>" + obra.parroquia.canton.nombre + "</strong>, a los "
                            actaInstance.descripcion += "<strong>" + NumberToLetterConverter.numberToLetter(hoy.format("dd").toInteger()) + " (" + hoy.format("dd") + ")</strong> días del mes de "
                            actaInstance.descripcion += "<strong>" + meses[hoy.format("MM").toInteger()] + "</strong> del <strong>" + hoy.format("yyyy") + "</strong>, nos constituímos "
                        } else {
                            actaProv = Acta.findAllByContratoAndTipo(contrato, 'P')
                            if (actaProv.size() == 1) {
                                actaProv = actaProv[0]
                                actaInstance.descripcion = actaProv.descripcion
                            }
                        }
                    } else if (actas.size() == 1) {
                        actaInstance = actas[0]
                        sec = actaInstance.secciones
                    } else {
                        actaInstance = actas.find { it.tipo == 'P' }
                        sec = actaInstance.secciones
                    }
                    sec.each { s ->
                        def objSec = [:]
                        objSec.id = s.id
                        objSec.numero = s.numero
                        objSec.titulo = s.titulo
                        objSec.parrafos = []
                        s.parrafos.each { p ->
                            objSec.parrafos.add([
                                    id: p.id,
                                    numero: p.numero,
                                    contenido: p.contenido,
                                    tipoTabla: p.tipoTabla
                            ])
                        }
                        secciones.add(objSec)
                    }
                }
            } //es create
            def jsonSecciones = new JsonBuilder(secciones)

//            println jsonSecciones.toPrettyString()

            def editable = actaInstance.registrada == 0 && !actaInstance.fechaRegistro
            if (tipo == 'D') {
                if (actaProv.registrada != 1 || !actaProv.fechaRegistro) {
                    flash.message = "No ha registrado el acta provisional, no puede generar el acta definitiva."
                    redirect(action: "errores", params: [contrato: params.contrato])
                    return
                }

                def diasDefinitiva = 180
                def fechaProv = actaProv.fechaRegistro
                def hoy = new Date()

                /* TODO:
                        esto valida q hayan pasado los 180 dias desde el registro del acta provisional para poder hacer el acta definitiva
                 */
//                if (hoy - fechaProv < diasDefinitiva) {
//                    flash.message = "El acta provisional fue registrada el " + (fechaProv.format("dd-MM-yyyy")) + ". Tiene que esperar " + diasDefinitiva + " días para generar el acta definitiva (" + (fechaProv + diasDefinitiva).format("dd-MM-yyyy") + ")"
//                    redirect(action: "errores", params: [contrato: params.contrato])
//                    return
//                }
            }

            return [actaInstance: actaInstance, secciones: jsonSecciones, editable: editable, tipos: tipos, actaProv: actaProv]
        } else {
            flash.message = "No puede crear un acta sin contrato"
            redirect(action: 'errores')
        }
    }

    def errores() {
        return [contrato: params.contrato]
    }

    def updateDescripcion() {
        def acta = Acta.get(params.id)
        acta.descripcion = params.descripcion
        if (acta.save(flush: true)) {
            render "OK_Descripción guardada"
        } else {
            render "NO_" + renderErrors(bean: acta)
        }
    }

    def form_ajax() {
        def actaInstance = new Acta(params)
        if (params.id) {
            actaInstance = Acta.get(params.id)
            if (!actaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Acta con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [actaInstance: actaInstance]
    } //form_ajax

    def registrar() {
        def acta = Acta.get(params.id)
        acta.registrada = 1
        acta.fechaRegistro = new Date()
        if (acta.save(flush: true)) {
            flash.clase = "alert-success"
            flash.message = "El acta ha sido registrada exitosamente"
        } else {
            flash.clase = "alert-error"
            flash.message = "Ha ocurrido un error al registrar el acta: " + g.renderErrors(bean: acta)
        }
        redirect(action: "form", id: params.id)
    }

    def save() {
        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        if (params.numero) {
            params.numero = params.numero.toUpperCase()
        }
        def actaInstance
        if (params.id) {
            actaInstance = Acta.get(params.id)
            if (!actaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Acta con id " + params.id
                redirect(action: 'form', params: [contrato: params.contrato.id])
                return
            }//no existe el objeto
            actaInstance.properties = params
        }//es edit
        else {
            actaInstance = new Acta(params)
        } //es create
        if (!actaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Acta " + (actaInstance.id ? actaInstance.id : "") + "</h4>"

            str += "<ul>"
            actaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'form', params: [contrato: params.contrato.id])
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Acta " + actaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Acta " + actaInstance.id
        }
        redirect(action: 'form', id: actaInstance.id)
    } //save

    def show_ajax() {
        def actaInstance = Acta.get(params.id)
        if (!actaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Acta con id " + params.id
            redirect(action: "list")
            return
        }
        [actaInstance: actaInstance]
    } //show

    def delete() {
        def actaInstance = Acta.get(params.id)
        if (!actaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Acta con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            actaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Acta " + actaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Acta " + (actaInstance.id ? actaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller
