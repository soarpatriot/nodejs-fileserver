// Generated by CoffeeScript 1.6.3
/* respone file  binary for restful url
*/


(function() {
  var fs, http, path;

  http = require('http');

  path = require('path');

  fs = require('fs');

  exports.show(function(req, res) {
    var fileId, readPath;
    fileId = req.params.id;
    readPath = '';
    return path.exists(realPath, exists(function() {
      if (!exists) {
        return res.send('No exist!');
      } else {
        return fs.readFile(readPath, 'binary', function(err, file) {
          if (err) {
            res.writeHead(500, {
              'Content-Type': 'text/html'
            });
            return res.end(err);
          } else {
            res.writeHead(200, {
              'Content-Type': 'text/html'
            });
            res.write(file, "binary");
            return res.end;
          }
        });
      }
    }));
  });

}).call(this);
