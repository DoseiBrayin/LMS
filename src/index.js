const express = require("express");
const morgan = require('morgan')

//Inicializar
const app = express();

//COnfiguracion
app.set('port',process.env.PORT || 4000)

//Middleware
app.use(morgan('dev'))

//Variables globales

//Rutas

//Publico



//Starting the server
app.listen(app.get('port'), () => {
    console.log('server on port: ', app.get('port'))
});

