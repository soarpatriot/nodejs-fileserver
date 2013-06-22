### respone file  binary for restful url


###
http = require('http')
path = require('path')
fs = require('fs')

exports.show (req,res)->
    fileId = req.params.id
    readPath = ''
    path.exists realPath,exists ->
        if !exists
            res.send 'No exist!'
        else
            fs.readFile readPath, 'binary', (err,file)->
                if err
                    res.writeHead 500, {'Content-Type': 'text/html'}
                    res.end err
                else
                    res.writeHead 200,
                                  'Content-Type': 'text/html'
                    res.write(file,"binary")
                    res.end
