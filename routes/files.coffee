### respone file  binary for restful url


###
http = require('http')
path = require('path')
fs = require('fs')
zlib = require("zlib")
setting = require('../config/setting')
mime = require('../config/mime')


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
      raw = fs.createReadStream realPath
      acceptEncoding = req.headers['accept-encoding'] || ""

      if acceptEncoding.match(/\bgzip\b/)
        res.set({'Content-Encoding': 'gzip'});
        raw.pipe(zlib.createGzip()).pipe(res);

      else if acceptEncoding.match(/\bdeflate\b/)
        res.set({'Content-Encoding': 'gzip'})
        raw.pipe(zlib.createDeflate()).pipe(res)

      else
        res.set(200,{'Content-Type': contentType})
        raw.pipe(res)
