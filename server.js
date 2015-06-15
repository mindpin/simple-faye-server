var http       = require('http');
var faye       = require('faye');
var deflate    = require('permessage-deflate');
var faye_redis = require('faye-redis');


var bayeux = new faye.NodeAdapter({
  mount: '/faye',
  timeout: 45,
  engine: {
    type:   faye_redis,
    host:   '127.0.0.1',
    port:   6379
  }
});



// zlib
bayeux.addWebsocketExtension(deflate);

// 监听
bayeux.on('handshake', function(clientId) {
  // event listener logic
});

bayeux.on('subscribe', function(clientId, channel) {
  // event listener logic
});

bayeux.on('unsubscribe', function(clientId, channel) {
  // event listener logic
});

bayeux.on('publish', function(clientId, channel, data) {
  // event listener logic
});

bayeux.on('disconnect', function(clientId) {
  // event listener logic
});


var server = http.createServer();
bayeux.attach(server);
server.listen(95271);
console.log("faye server is listening http://127.0.0.1:95271");
