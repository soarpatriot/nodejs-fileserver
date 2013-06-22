// Generated by CoffeeScript 1.6.3
(function() {
  var app, express, http, path, routes;

  express = require('express');

  routes = require('./routes');

  http = require('http');

  path = require('path');

  app = express();

  app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express["static"](path.join(__dirname, "public")));
    return app.use(app.router);
  });

  app.configure('development', function() {
    return app.use(express.errorHandler);
  });

  app.get('/', routes.index);

  app.get('/file/:id', routes.show);

  http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + app.get('port'));
  });

}).call(this);
