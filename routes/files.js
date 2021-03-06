// Generated by CoffeeScript 1.6.3
/* respone file  binary for restful url
*/


(function() {
  var fs, http, mime, path, setting, util, zlib;

  http = require('http');

  path = require('path');

  fs = require('fs');

  zlib = require("zlib");

  setting = require('../config/setting');

  mime = require('../config/mime');

  util = require('util');

  exports.show = function(req, res) {
    var contentType, ext, extName, fileId, realPath;
    fileId = req.params.id;
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
        res.set(404, {
          'Content-Type': "text/plain"
        });
        return res.send('No exist!');
      } else {
        return fs.stat(realPath, function(err, stat) {
          var acceptEncoding, raw, size;
          size = stat.size;
          console.log(size);
          raw = fs.createReadStream(realPath);
          acceptEncoding = req.headers['accept-encoding'] || "";
          if (acceptEncoding.match(/\bgzip\b/)) {
            res.set({
              'Content-Encoding': 'gzip',
              'Content-Type': contentType,
              'Content-Length': 100
            });
            return raw.pipe(zlib.createGzip()).pipe(res);
          } else if (acceptEncoding.match(/\bdeflate\b/)) {
            res.set({
              'Content-Encoding': 'gzip',
              'Content-Length': size
            });
            return raw.pipe(zlib.createDeflate()).pipe(res);
          } else {
            res.set({
              'Content-Type': contentType,
              'Content-Length': size
            });
            return raw.pipe(res);
          }
        });
      }
    });
  };

  exports.display = function(req, res) {
    var contentType, ext, extName, fileId, realPath;
    fileId = req.params[0];
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
          return fs.readFile(realPath, "binary", function(err, file) {
            if (err) {
              res.writeHead(500, {
                'Content-Type': contentType
              });
              return res.end(err);
            } else {
              res.writeHead(200, {
                'Content-Type': contentType,
                'Content-Length': stat.size
              });
              res.write(file, "binary");
              return res.end();
            }
          });
        });
      }
    });
  };

}).call(this);
