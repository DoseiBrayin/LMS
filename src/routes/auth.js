const express = require('express')
const router = express.Router()

router.get('/login', (req, res) => {
    req.flash('success', 'Link Updated Successfully');
    res.render("login/loginvista")
})

router.post('/login', (req, res) => {
    console.log(req.body)
    res.render("login/loginvista")
})

module.exports = router