### respone file  binary for restful url


###
http = require('http')
path = require('path')
fs = require('fs')
zlib = require("zlib")
setting = require('../config/setting')
mime = require('../config/mime')
util = require('util')

#respone file stream to the request
exports.show = (req,res)->

  fileId = req.params.id
  ##fileId = '12.png'
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

  fs.exists realPath, (exists)->
    if !exists
      res.set(404,{'Content-Type': "text/plain"})
      res.send 'No exist!'
    else
      fs.stat realPath, (err, stat) ->
        size = stat.size
        console.log size
        raw = fs.createReadStream realPath
        #size = 1024000
        acceptEncoding = req.headers['accept-encoding'] || ""

        if acceptEncoding.match(/\bgzip\b/)
          res.set({'Content-Encoding': 'gzip','Content-Type': contentType,'Content-Length':100});
          raw.pipe(zlib.createGzip()).pipe(res);

        else if acceptEncoding.match(/\bdeflate\b/)
          res.set({'Content-Encoding': 'gzip','Content-Length':size})
          raw.pipe(zlib.createDeflate()).pipe(res)


        else
          res.set({'Content-Type': contentType,'Content-Length':size})
          raw.pipe(res)



exports.display = (req,res)->

  fileId = req.params[0]
  ##fileId = '12.png'
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

  fs.exists realPath, (exists)->
    if !exists
      #res.writeHead(404,{'Content-Type': "text/plain"})
      res.send 'No exist!'
    else
      fs.stat realPath, (err, stat) ->
        fs.readFile realPath, "binary",  (err, file) ->
          if (err)
            res.writeHead(500, {'Content-Type': contentType})
            res.end(err)
          else

            res.writeHead(200, {'Content-Type': contentType,'Content-Length':stat.size})
            res.write(file, "binary")
            res.end()
