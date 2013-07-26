## for app.js server run js

express = require 'express'
http = require 'http'
path = require 'path'
uuid = require('node-uuid');
upload = require('jquery-file-upload-middleware')

files = require './routes/files'

upload.configure
  uploadDir:  __dirname + '/assets/files'
  uploadUrl: '/upload'


app = express()
app.configure ->

    app.set('port', process.env.PORT || 8080)
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use(express.favicon())
    app.use(express.logger('dev'))

    #file upload
    app.use '/upload', (req, res, next) ->
      upload.fileHandler()(req, res, next)
    upload.on 'begin', (fileInfo) ->
      originName= fileInfo.originalName
      newName = uuid.v1();
      fileInfo.name = newName+path.extname(originName)

    upload.on 'end',  (fileInfo) ->
      urlStr = fileInfo.url
      console.log "urlStr: "+urlStr
      fileInfo.url = urlStr.replace("/upload","/files")


    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express["static"](path.join(__dirname, "public")))
    app.use(app.router)

app.configure 'development', ->
    app.use express.errorHandler

# set cross domain allow, current allow access
app.all '*', (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Expose-Headers","Content-Length");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By",' 3.2.1')
    res.header("Content-Type", "application/json;charset=utf-8");
    next();

app.get('/files/:id', files.display)

http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port " + app.get('port')

