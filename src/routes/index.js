const express = require('express')
const router = express.Router()
const pool = require('../database')

router.get('/', (req, res) => {
    res.send('Hello world')
})

module.exports = router