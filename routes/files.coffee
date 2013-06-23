### respone file  binary for restful url


###
http = require('http')
path = require('path')
fs = require('fs')
zlib = require("zlib")
setting = require('../config/setting')
mime = require('../config/mime')

exports.show = (req,res)->

    fileId = req.params.id
    fileId = '12.png'
    realPath = path.resolve(setting.rootPath() + 'assets/files/'+fileId)

    ###
        ext = path.extname(realPath)
        ext = ext ? ext.slice(1)
        contentType = mime[ext] || "text/plain"
        res.set(200, {'Content-Type': contentType});
    ###
    console.log('realPaht: '+realPath)

    fs.exists realPath, (exists)->
      if !exists
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
          res.set(200, "Ok")
          raw.pipe(res)

