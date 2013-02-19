package janus

import org.springframework.dao.DataIntegrityViolationException

class RubroController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def buscadorService
    def preciosService

    def index() {
        redirect(action: "list", params: params)
    } //index


    def gruposPorClase() {
        def clase = Grupo.get(params.id)
        def grupos = SubgrupoItems.findAllByGrupo(clase)
        def sel = g.select(id: "selGrupo", name: "rubro.suggrupoItem.id", from: grupos, "class": "span12", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
        def js = "<script type='text/javascript'>"
        js += '$("#selGrupo").change(function () {'
        js += 'var grupo = $(this).val();'
        js += '$.ajax({'
        js += 'type    : "POST",'
        js += 'url     : "' + createLink(action: 'subgruposPorGrupo') + '",'
        js += 'data    : {'
        js += 'id : grupo'
        js += '},'
        js += 'success : function (msg) {'
        js += '$("#selSubgrupo").replaceWith(msg);'
        js += '}'
        js += '});'
        js += '});'
        js += "</script>"
        render sel + js
    }

    def subgruposPorGrupo() {
        def grupo = SubgrupoItems.get(params.id)
        def subgrupos = DepartamentoItem.findAllBySubgrupo(grupo)
        def sel = g.select(id: "selSubgrupo", name: "rubro.departamento.id", from: subgrupos, "class": "span12", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
        render sel
    }

    def ciudadesPorTipo() {
        def tipo = params.id
        def ciudades = Lugar.findAllByTipo(tipo)
        def sel = g.select(id: "ciudad", name: "item.ciudad.id", from: ciudades, "class": "span10", optionKey: "id", optionValue: "descripcion")
        render sel
    }

    def rubroPrincipal() {
        def rubro
        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]
        def grupos = []
        def volquetes = []
        def choferes = []
        def aux = Parametros.get(1)
        def grupoTransporte=DepartamentoItem.findAllByTransporteIsNotNull()
        grupoTransporte.each {
            if(it.transporte.codigo=="H")
                choferes=Item.findAllByDepartamento(it)
            if(it.transporte.codigo=="T")
                volquetes=Item.findAllByDepartamento(it)
        }
        grupos.add(Grupo.get(4))
        grupos.add(Grupo.get(5))
        grupos.add(Grupo.get(6))
        if (params.idRubro) {
            rubro = Item.get(params.idRubro)
            def items=Rubro.findAllByRubro(rubro)
            items.sort{it.item.codigo}
            [campos: campos, rubro: rubro, grupos: grupos,items:items,choferes:choferes,volquetes:volquetes,aux:aux]
        } else {
            [campos: campos, grupos: grupos,choferes:choferes,volquetes:volquetes,aux:aux]
        }
    }

    def getDatosItem() {
//        println "get datos items "+params
        def item = Item.get(params.id)
//        println "render "+  item.id + "&" + item.codigo + "&" + item.nombre + "&" + item.unidad.codigo + "&" + item.rendimiento+"&"+((item.tipoLista)?item.tipoLista?.id:"0")
        render "" + item.id + "&" + item.codigo + "&" + item.nombre + "&" + item.unidad?.codigo?.trim() + "&" + item.rendimiento+"&"+((item.tipoLista)?item.tipoLista?.id:"0")
    }

    def addItem() {
        println "add item " + params
        def rubro = Item.get(params.rubro)
        def item = Item.get(params.item)
        def detalle
        detalle = Rubro.findByItemAndRubro(item, rubro)
        if (!detalle)
            detalle = new Rubro()
        detalle.rubro = rubro
        detalle.item = item
        detalle.cantidad = params.cantidad.toDouble()
        if(detalle.item.id.toInteger()==2868 || detalle.item.id.toInteger()==2869 || detalle.item.id.toInteger()==2870){
            detalle.cantidad=1
            if (detalle.item.id.toInteger()==2868)
                detalle.rendimiento=1
            if (detalle.item.id.toInteger()==2869)
                detalle.rendimiento=1
            if (detalle.item.id.toInteger()==2870)
                detalle.rendimiento=1
        }else{
            detalle.rendimiento = params.rendimiento.toDouble()
        }
        if (detalle.item.departamento.subgrupo.grupo.id==2)
            detalle.cantidad=Math.ceil(detalle.cantidad)
        detalle.fecha = new Date()
        if (detalle.item.departamento.subgrupo.grupo.id==1)
            detalle.rendimiento=1
        if (!detalle.save(flush: true)) {
            println "detalle " + detalle.errors
        } else {
            rubro.fechaModificacion=new Date()
            rubro.save(flush: true)
            render "" + item.departamento.subgrupo.grupo.id + ";" + detalle.id+";"+detalle.item.id+";"+detalle.cantidad+";"+detalle.rendimiento+"&"+((item.tipoLista)?item.tipoLista?.id:"0")
        }
    }

    def buscaItem() {
//        println "busca item "+params
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaItem", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'var idReg = $(this).attr("regId");'
        funcionJs += '$.ajax({type: "POST",url: "' + g.createLink(controller: 'rubro', action: 'getDatosItem') + '",'
        funcionJs += ' data: "id="+idReg,'
        funcionJs += ' success: function(msg){'
        funcionJs += 'var parts = msg.split("&");console.log(parts);'
        funcionJs += ' $("#item_id").val(parts[0]);'
        funcionJs += '$("#cdgo_buscar").val(parts[1]);'
        funcionJs += '$("#item_desc").val(parts[2]);'
        funcionJs += '$("#item_unidad").val(parts[3]);'
        funcionJs += '$("#item_tipoLista").val(parts[5]);'
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += '}'
        funcionJs += '});'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 1"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscaRubro() {

        def listaTitulos = ["Código", "Descripción","Unidad"]
        def listaCampos = ["codigo", "nombre","unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'rubroPrincipal', controller: 'rubro') + '?idRubro="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscaRubroComp() {
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'if($("#rubro__id").val()*1>0){ '
        funcionJs += '   if(confirm("Esta seguro?")){'
        funcionJs += '        var idReg = $(this).attr("regId");'
        funcionJs += '        var datos="rubro="+$("#rubro__id").val()+"&copiar="+idReg;'
        funcionJs += '       $.ajax({type: "POST",url: "' + g.createLink(controller: 'rubro', action: 'copiarComposicion') + '",'
        funcionJs += '            data: datos, '
        funcionJs += '            success: function(msg){ '
        funcionJs += '            $("#modal-rubro").modal("hide");'
        funcionJs += '               window.location.reload(true) '
        funcionJs += '           }   '
        funcionJs += '        });'
        funcionJs += '    } '
        funcionJs += '}else{ '
        funcionJs += '    $.box({ '
        funcionJs += '       imageClass: "box_info",'
        funcionJs += '        text      : "Primero guarde el rubro o escoja un de la lista",'
        funcionJs += '       title     : "Alerta", '
        funcionJs += '        iconClose : false,'
        funcionJs += '       dialog    : {'
        funcionJs += '           resizable    : false,'
        funcionJs += '            draggable    : false,'
        funcionJs += '           buttons      : {'
        funcionJs += '                "Aceptar" : function () {}'
        funcionJs += '           }'
        funcionJs += '        }'
        funcionJs += '    });'
        funcionJs += '}'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def copiarComposicion() {
        println "copiar " + params
        if (request.method == "POST") {
            def rubro = Item.get(params.rubro)
            def copiar = Item.get(params.copiar)
            def detalles = Rubro.findAllByRubro(copiar)
            detalles.each {
                def tmp = Rubro.findByRubroAndItem(rubro, it.item)
                if (!tmp) {
                    def nuevo = new Rubro()
                    nuevo.rubro = rubro
                    nuevo.item = it.item
                    nuevo.cantidad = it.cantidad
                    nuevo.fecha = new Date()
                    if (!nuevo.save(flush: true))
                        println "Error: copiar composicion " + nuevo.errors

                }
            }
            rubro.fechaModificacion=new Date()
            rubro.save(flush: true)
            render "ok"
        } else {
            response.sendError(403)
        }
    }


    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [rubroInstanceList: Rubro.list(params), rubroInstanceTotal: Rubro.count(), params: params]
    } //list

    def form_ajax() {
        def rubroInstance = new Rubro(params)
        if (params.id) {
            rubroInstance = Rubro.get(params.id)
            if (!rubroInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Rubro con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [rubroInstance: rubroInstance]
    } //form_ajax

    def save() {
        println "save rubro " + params.rubro
        def rubro
        if (params.rubro.id) {
            rubro = Item.get(params.rubro.id)
            params.remove("rubro.fecha")
            rubro.tipoItem = TipoItem.get(2)
            rubro.fechaModificacion=new Date()
        } else {
            rubro = new Item(params)
            params.rubro.fecha = new Date()
            rubro.tipoItem = TipoItem.get(2)
        }

        if (params.rubro.registro != "R") {
            params.rubro.registro = "N"
            rubro.fechaRegistro = null
        } else {
            rubro.fechaRegistro = new Date()
        }
        rubro.properties = params.rubro
        rubro.tipoItem = TipoItem.get(2)
        println "ren " + rubro.rendimiento
        if (!rubro.save(flush: true)) {
            println "error " + rubro.errors
        }

        redirect(action: 'rubroPrincipal', params: [idRubro: rubro.id])
    } //save

    def show_ajax() {
        def rubroInstance = Rubro.get(params.id)
        if (!rubroInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Rubro con id " + params.id
            redirect(action: "list")
            return
        }
        [rubroInstance: rubroInstance]
    } //show

    def eliminarRubroDetalle() {
//        println "eliminarRubroDetalle "+params
        if (request.method == "POST") {
            def rubro = Rubro.get(params.id)
            try {
                rubro.delete(flush: true)
                render "Registro eliminado"
            }
            catch (DataIntegrityViolationException e) {
                render "No se pudo eliminar el rubro"
            }
        } else {
            response.sendError(403)
        }

    }


    def borrarRubro() {
//        println "borrar rubro "+params
        def rubroInstance = Item.get(params.id)
        if (!rubroInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Rubro con id " + params.id
            redirect(action: "list")
            return
        }

        def vo = VolumenesObra.findAllByItem(rubroInstance)
        def obras = Obra.findAllByChoferOrVolquete(rubroInstance,rubroInstance)
//        println "vo "+vo
//        println "obras "+obras
        if (vo.size()+obras.size()>0){
            render "Error"
            return
        }else{
            try {
                def comp = Rubro.findAllByRubro(rubroInstance)
                comp.each {
                    it.delete(flush: true)
                }
                rubroInstance.delete(flush: true)
                render "ok"
                return
            }
            catch (DataIntegrityViolationException e) {
                println "error del rubro "+e
                render "Error"
                return
            }
        }


    } //delete

    def getPrecios() {
//        println "get precios "+params
        def lugar = Lugar.get(params.ciudad)
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        def listas = []
        def conLista = []
        listas=params.listas.split("#")
//        println "listas "+listas
        parts.each {
            if (it.size() > 0){
                def item=Rubro.get(it).item
                if (item.tipoLista){
                    conLista.add(item)
//                    println "con lista "+item.tipoLista
                }else{
                    items.add(item)
                }

            }

        }
        def precios=""
//        println "items "+items+"  con lista "+conLista
        if (items.size()>0){
            precios = preciosService.getPrecioItemsString(fecha, lugar, items)
        }
//        println "precios "+precios


        conLista.each {
//            println "tipo "+ it.tipoLista.id.toInteger()
            precios+=preciosService.getPrecioItemStringListaDefinida(fecha, listas[it.tipoLista.id.toInteger()-1], it.id)
        }


//        println "precios final " + precios
//        println "--------------------------------------------------------------------------"
        render precios
    }
    def getPreciosTransporte() {
//        println "get precios "+params
        def lugar = Lugar.get(params.ciudad)
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        parts.each {
            if (it.size() > 0)
                items.add(Item.get(it))
        }
        def precios = preciosService.getPrecioItemsString(fecha, lugar, items)
//        println "precios " + precios
        render precios
    }


    def transporte(){
//        println "transporte "+params
        def idRubro = params.id
        def fecha = new Date().parse("dd-MM-yyyy",params.fecha)
        def listas = params.listas
        def parametros = ""+idRubro+",'"+fecha.format("yyyy-MM-dd")+"',"+listas+","+params.dsp0+","+params.dsp1+","+params.dsv0+","+params.dsv1+","+params.dsv2+","+params.chof+","+params.volq
//        println "paramtros " +parametros
        def res = preciosService.rb_precios(parametros,"")

        def tabla='<table class="table table-bordered table-striped table-condensed table-hover"> '
        def total = 0
        tabla+="<thead><tr><th colspan=7>Transporte</th></tr><tr><th style='width: 80px;'>Código</th><th style='width:610px'>Descripción</th><th>Pes/Vol</th><th>Cantidad</th><th>Distancia</th><th>Unitario</th><th>C.Total</th></thead><tbody>"
//        println "rends "+rendimientos

//        println "res "+res
        res.each {r->
            if(r["parcial_t"]>0){
//                println "en tabla "+r["itemcdgo"]
                tabla+="<tr>"
                tabla+="<td style='width: 80px;'>"+r["itemcdgo"]+"</td>"
                tabla+="<td>"+r["itemnmbr"]+"</td>"
                tabla+="<td style='width: 50px;text-align: right'>"+r["itempeso"]+"</td>"
                tabla+="<td style='width: 50px;text-align: right'>"+r["rbrocntd"]+"</td>"
                tabla+="<td style='width: 50px;text-align: right'>"+r["distancia"]+"</td>"
                tabla+="<td style='width: 50px;text-align: right'>"+(r["parcial_t"]/(r["itempeso"]*r["rbrocntd"]*r["distancia"])).toFloat().round(5)+"</td>"
                tabla+="<td style='width: 50px;text-align: right'>"+r["parcial_t"]+"</td>"
                total+=r["parcial_t"]
                tabla+="</tr>"
            }

        }
        tabla+="<tr><td><b>SUBTOTAL</b></td><td></td><td></td><td></td><td></td><td></td><td style='width: 50px;text-align: right;font-weight: bold' class='valor_total'>${total}</td>"
        tabla+="</tbody></table>"

        render(tabla)
//
//        pg: select * from rb_precios(293, 4, '1-feb-2008', 50, 70, 0.1015477897561282, 0.1710401760227313);
    }

    def showFoto(){
        def rubro = Item.get(params.id)
        [rubro: rubro]
    }

    def uploadFile(){
//        println "upload "+params
        def path = servletContext.getRealPath("/") + "rubros/"   //web-app/rubros
        def rubro = Item.get(params.rubro)
        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext
            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            if (ext=="jpg" || ext=="JPG" || ext=="png" || ext=="PNG" || ext=="gif" || ext=="GIF" || ext=="jpeg" || ext=="JPEG"){
                def ahora = new Date()
                fileName = "r_"+rubro.id+"_"+ahora.format("dd_MM_yyyy_hh_mm_ss")
                def fn = fileName
                fileName = fileName + "." + ext
                def pathFile = path + fileName
                def src = new File(pathFile)
                def i = 1
                def file = new File(pathFile)
                f.transferTo(file)

                rubro.foto= g.resource(dir: "rubros")+"/"+fileName
                rubro.save(flush: true)


            }else{
                flash.message="Error: Los formatos permitidos son: JPG, JPEG, GIF, PNG"
            }


        }else{
            flash.message="Error: Los formatos permitidos son: JPG, JPEG, GIF, PNG"
        }
        redirect(action: "showFoto",id: rubro.id)
        return


    }


} //fin controller
