## for server.js server run js

http = require('http')
path = require('path')
fs = require('fs')
PORT = 3000;

setting = require('./config/setting')

server = http.createServer (req,res)->
    ##fileId = req.params.id
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

server.listen(PORT);
console.log("Server runing at port: " + PORT + ".");