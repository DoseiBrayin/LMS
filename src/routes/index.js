const express = require('express')
const router = express.Router()
const pool = require('../database')

router.get('/', (req, res) => {
    res.render("index")
})

router.get('/login', (req, res) => {
    req.flash('success', 'Link Updated Successfully');
    res.render("login/loginvista")
})

module.exports = router