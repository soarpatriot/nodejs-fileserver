## for app.js server run js

express = require 'express'
routes = require './routes'
files = require './routes/files'
http = require 'http'
path = require 'path'

app = express()
app.configure ->
    app.set('port', process.env.PORT || 3000)
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use(express.favicon())
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express["static"](path.join(__dirname, "public")))
    app.use(app.router)

app.configure 'development', ->
    app.use express.errorHandler

app.get('/', routes.index)
app.get('/files/:id', files.show)

http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port " + app.get('port')
