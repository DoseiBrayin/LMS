const express = require('express')
const pool = require('../database')
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
//RUTAS DEL PROFESOR
router.get('/indexprofe', isLoggedIn,isTeacher,(req, res) => {
    res.render("links/profesor/indexProf")
})

module.exports = router