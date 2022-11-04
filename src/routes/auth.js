const express = require('express')
const router = express.Router()
const passport=require('passport')
const pool = require('../database')

router.get('/login', (req, res) => {
    res.render("login/loginvista")
})

router.post('/login', (req, res,next) => {
    passport.authenticate('local.signin',{
        successRedirect: '/links/indexest',
        failureRedirect:'/login',
        failureFlash: true
    })(req,res,next);
});

module.exports = router