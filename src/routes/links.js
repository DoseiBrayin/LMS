const express = require('express')
const pool = require('../database')
const PDF = require('pdfkit-construct')
const router = express.Router()
const {isLoggedIn,isStudent,isTeacher,isAdmin} = require('../lib/authentication')


//RUTAS DEL ESTUDIANTE
router.get('/cursos',isLoggedIn,isStudent, async (req, res) => {
    const sql = 'SELECT grupo_asignatura_id_asig,t.*,s.nombre as nombre_asig,p.nombre FROM (estudiante_has_grupo inner join (grupo g inner join tiempo t on g.tiempo_idtiempo=t.idtiempo) on estudiante_has_grupo.grupo_idgrupo=g.idgrupo) inner join asignatura s on estudiante_has_grupo.grupo_asignatura_id_asig=s.id_asig inner join profesor p on estudiante_has_grupo.grupo_profesor_cedula=p.cedula where estudiante_has_grupo.estudiante_usuario_idusuario = ?'
    const cursos =await pool.query(sql,req.user.idusuario)
    const sql_pensum = 'select e.nombre,e.cedula,e.pensum_idpensum,p.nombre as pensum  from pensum p inner join estudiante e on p.idpensum=e.pensum_idpensum where e.usuario_idusuario = ?'
    const  pensum = await pool.query(sql_pensum,req.user.idusuario)
    res.render("links/estudiante/cursosEst",{cursos,pensum})
})

router.get('/indexest', isLoggedIn,isStudent, (req, res) => {
    console.log(req.user)
    res.render("links/estudiante/indexest")
    
})
// RUTAS DEL ADMINISTRADOR
router.get('/indexadmin', isLoggedIn,isAdmin, (req, res) => {
    res.render("links/admin/indexAdmin.hbs")
})

router.get('/adminpanel', isLoggedIn,isAdmin, (req, res) => {
    res.render("links/admin/adminpanel.hbs")
})

//RUTAS DEL PROFESOR
router.get('/indexprofe', isLoggedIn,isTeacher,(req, res) => {
    res.render("links/profesor/indexProf")
})
router.get('/profe/cursos', isLoggedIn,isTeacher,async(req, res) => {
    const sql = 'SELECT cedula FROM `profesor` WHERE usuario_idusuario = ?'
    const cedula = await pool.query(sql,req.user.idusuario)
    const sql2 = 'SELECT idgrupo,profesor_cedula,dia,hora_inicio,hora_fin,nombre FROM `grupo` INNER JOIN `tiempo` on tiempo_idtiempo=idtiempo INNER JOIN `asignatura` on asignatura_id_asig=id_asig WHERE profesor_cedula = ?;'
    const cursos = await pool.query(sql2,cedula[0].cedula)
    res.render("links/profesor/cursoProf",{cursos})
})
router.get('/profe/lista:idgrupo', isLoggedIn,isTeacher,async(req, res) => {
    const grupo = req.params
    const sql = 'SELECT e.* FROM `estudiante_has_grupo` INNER JOIN `estudiante` e on estudiante_has_grupo.estudiante_cedula= e.cedula WHERE estudiante_has_grupo.grupo_idgrupo = '+ grupo.idgrupo
    const lista = await pool.query(sql)
    res.render("links/profesor/listaProf",{lista})
})
router.get('/profe/descargarlista:idgrupo', isLoggedIn,isTeacher,async(req, res) => {
    const grupo = req.params
    const sql = 'SELECT e.* FROM `estudiante_has_grupo` INNER JOIN `estudiante` e on estudiante_has_grupo.estudiante_cedula= e.cedula WHERE estudiante_has_grupo.grupo_idgrupo = '+ grupo.idgrupo
    const lista = await pool.query(sql)

    //SE CREA EL PDF
    let doc = new PDF({ margin: 30, size: 'A4'})
    const stream = res.writeHead(200,{
        'Content-Type' : 'aplication/pdf',
        'Content-disposition' : 'attachment;filename="lista.pdf"'
    })

    const listado = lista.map((data)=>{
        const estudiantes ={
            cedula:data.cedula,
            nombre:data.nombre,
            email:data.correo,
            pensum:data.pensum_idpensum,
            usuario:data.usuario_idusuario,
        }
        return estudiantes
    })

    if(listado.length == 0){
        doc.text('No se encuentran alumnos matriculados en este grupo')
    }else{
        //CREO EL DOCUMENTO
    doc.addTable([
        {key:'cedula',label:'cedula',aling:'left'},
        {key:'nombre',label:'nombre',aling:'left'},
        {key:'email',label:'email',aling:'left'},
        {key:'pensum',label:'pensum',aling:'left'},
        {key:'usuario',label:'user',aling:'left'},
    ],listado,{
        headBackground  : '#28a745',
        headColor: "#FFFFFF",
        border: null,
        width: "auto",
        striped: true,
        stripedColors: ["#f6f6f6", "#f6f6f6"],
        cellsPadding: 10,
        marginLeft: 45,
        marginRight: 45,
        headAlign: 'center'
    })

    doc.setDocumentHeader({}, () => {
        doc.lineJoin('miter')
            .rect(0, 0, doc.page.width, doc.header.options.heightNumber).fill("#28a745");

        doc.fill("#FFFFFF")
            .fontSize(20)
            .text(`LISTADO DE ESTUDIANTES DEL GRUPO ${grupo.idgrupo}`, doc.header.x, doc.header.y);
    });
    doc.render()
    }

    
    
    doc.on('data',(data)=>{
        stream.write(data)
    })
    doc.on('end',()=>{stream.end()})

    doc.end()


})
module.exports = router