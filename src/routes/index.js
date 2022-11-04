const express = require('express')
const router = express.Router()
const pool = require('../database')

router.get('/', (req, res) => {
    res.render("indexest")
})

router.get('/cursos', (req, res) => {
    res.render("cursosEst")
})

router.get('/login', (req, res) => {
    res.render("layouts/Index/loginvista")
})

module.exports = router