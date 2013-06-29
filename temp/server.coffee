## for server.js server run js

http = require('http')
path = require('path')
fs = require('fs')
PORT = 3000;
zlib = require("zlib")

mime = require('./../config/mime')
setting = require('./../config/setting')

server = http.createServer (req,res)->

  fileId = req.params.id
  realPath = path.resolve(setting.rootPath() + 'assets/files/'+fileId)

  ##set content mime type
  ext = path.extname(realPath)
  extName = ext.slice(1)
  if ext
    ext = extName
  else
    ext = 'unkonwn'

  contentType = "text/plain"
  if mime.types[ext]
    contentType = mime.types[ext]

  console.log('realPaht: '+realPath)

  console.log('realPaht: '+realPath)
  fs.exists realPath, (exists)->
    if !exists
      res.send 'No exist!'

    else
      raw = fs.createReadStream realPath
      acceptEncoding = req.headers['accept-encoding'] || ""
      if acceptEncoding.match(/\bgzip\b/)
        res.writeHead(200, "Ok", {'Content-Encoding': 'gzip'});
        raw.pipe(zlib.createGzip()).pipe(res);
      else if acceptEncoding.match(/\bdeflate\b/)
        res.writeHead(200, "Ok", {'Content-Encoding': 'gzip'})
        raw.pipe(zlib.createDeflate()).pipe(res)
      else
        res.writeHead(200, "Ok")
        raw.pipe(res)

###
  raw = fs.createReadStream realPath, 'binary', (err,file)->
    if err
      res.writeHead 500, {'Content-Type': 'text/html'}
      res.end err
    else
      res.writeHead 200,
                    'Content-Type': 'text/html'
      res.write(file,'binary')
      res.end()
###
server.listen(PORT);
console.log("Server runing at port: " + PORT + ".");