### respone file  binary for restful url


###
http = require('http')
path = require('path')
fs = require('fs')
setting = require('../config/setting')

exports.show = (req,res)->
    fileId = req.params.id
    fileId = '12.png'
    realPath = path.resolve(setting.rootPath() + 'assets/files/'+fileId)
    console.log('realPaht: '+realPath)
    fs.exists realPath, (exists)->
        if !exists
                res.send 'No exist!'
        else
            fs.readFile realPath, 'binary', (err,file)->
                if err
                    res.writeHead 500, {'Content-Type': 'text/html'}
                    res.end err
                else
                    res.writeHead 200,
                       'Content-Type': 'text/html'
                    res.write(file,'binary')
                    res.end()
