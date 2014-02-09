// Generated by CoffeeScript 1.6.3
(function() {
  var PORT, fs, http, mime, path, server, setting, url, zlib;

  http = require('http');

  path = require('path');

  fs = require('fs');

  PORT = 8080;

  zlib = require("zlib");

  mime = require('./../config/mime');

  setting = require('./../config/setting');

  url = require("url");

  server = http.createServer(function(req, res) {
    var contentType, ext, extName, fileId, realPath;
    fileId = url.parse(req.url).pathname;
    realPath = path.resolve(setting.rootPath() + 'assets/files/' + fileId);
    ext = path.extname(realPath);
    extName = ext.slice(1);
    if (ext) {
      ext = extName;
    } else {
      ext = 'unkonwn';
    }
    contentType = "text/plain";
    if (mime.types[ext]) {
      contentType = mime.types[ext];
    }
    console.log('realPaht: ' + realPath);
    return fs.exists(realPath, function(exists) {
      if (!exists) {
        return res.send('No exist!');
      } else {
        return fs.stat(realPath, function(err, stat) {
          var acceptEncoding, raw;
          raw = fs.createReadStream(realPath);
          acceptEncoding = req.headers['accept-encoding'] || "";
          if (acceptEncoding.match(/\bgzip\b/)) {
            res.writeHead(200, "Ok", {
              'Content-Encoding': 'gzip',
              'Content-Length': stat.size
            });
            return raw.pipe(zlib.createGzip()).pipe(res);
          } else if (acceptEncoding.match(/\bdeflate\b/)) {
            res.writeHead(200, "Ok", {
              'Content-Encoding': 'gzip',
              'Content-Length': stat.size
            });
            return raw.pipe(zlib.createDeflate()).pipe(res);
          } else {
            res.writeHead(200, "Ok", {
              'Content-Length': stat.size
            });
            return raw.pipe(res);
          }
        });
      }
    });
  });

  /*
    raw = fs.createReadStream realPath, 'binary', (err,file)->
      if err
        res.writeHead 500, {'Content-Type': 'text/html'}
        res.end err
      else
        res.writeHead 200,
                      'Content-Type': 'text/html'
        res.write(file,'binary')
        res.end()
  */


  server.listen(PORT);

  console.log("Server runing at port: " + PORT + ".");

}).call(this);
