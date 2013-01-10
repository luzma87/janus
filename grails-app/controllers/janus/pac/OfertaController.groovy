package janus.pac

import org.springframework.dao.DataIntegrityViolationException

class OfertaController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [ofertaInstanceList: Oferta.list(params), params: params]
    } //list

    def form_ajax() {
        def ofertaInstance = new Oferta(params)
        if (params.id) {
            ofertaInstance = Oferta.get(params.id)
            if (!ofertaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Oferta con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [ofertaInstance: ofertaInstance]
    } //form_ajax

    def save() {
        def ofertaInstance
        if (params.id) {
            ofertaInstance = Oferta.get(params.id)
            if (!ofertaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Oferta con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            ofertaInstance.properties = params
        }//es edit
        else {
            ofertaInstance = new Oferta(params)
        } //es create
        if (!ofertaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Oferta " + (ofertaInstance.id ? ofertaInstance.id : "") + "</h4>"

            str += "<ul>"
            ofertaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Oferta " + ofertaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Oferta " + ofertaInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def ofertaInstance = Oferta.get(params.id)
        if (!ofertaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Oferta con id " + params.id
            redirect(action: "list")
            return
        }
        [ofertaInstance: ofertaInstance]
    } //show

    def delete() {
        def ofertaInstance = Oferta.get(params.id)
        if (!ofertaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Oferta con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            ofertaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Oferta " + ofertaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Oferta " + (ofertaInstance.id ? ofertaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller