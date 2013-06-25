// Generated by CoffeeScript 1.6.3
(function() {
  var app, express, files, http, path, upload, uuid;

  express = require('express');

  http = require('http');

  path = require('path');

  uuid = require('node-uuid');

  upload = require('jquery-file-upload-middleware');

  files = require('./routes/files');

  upload.configure({
    uploadDir: __dirname + '/assets/files',
    uploadUrl: '/upload',
    targetUrl: '/files'
  });

  app = express();

  app.configure(function() {
    app.set('port', process.env.PORT || 8080);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use('/upload', function(req, res, next) {
      return upload.fileHandler()(req, res, next);
    });
    upload.on('begin', function(fileInfo) {
      var newName, originName;
      originName = fileInfo.originalName;
      newName = uuid.v1();
      return fileInfo.name = newName + path.extname(originName);
    });
    upload.on('end', function(fileInfo) {
      var urlStr;
      urlStr = fileInfo.url;
      console.log("urlStr: " + urlStr);
      return fileInfo.url = urlStr.replace("/upload", "/files");
    });
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express["static"](path.join(__dirname, "public")));
    return app.use(app.router);
  });

  app.configure('development', function() {
    return app.use(express.errorHandler);
  });

  app.get('/files/:id', files.show);

  http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + app.get('port'));
  });

}).call(this);
