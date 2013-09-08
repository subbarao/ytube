var express = require('express');
var app = express();

app.configure(function(){
  app.use(express.static(__dirname +'/app/scripts'));
  app.use(express.static(__dirname +'/app/styles'));
  app.use(express.static(__dirname +'/app/bower_components'));
});

app.get('/', function(req, res){
  res.sendfile(__dirname + '/app/index.html');
});

app.listen(3000);
