var WebSocket = require('ws')

var WebSocketServer = require('ws').Server
var wss = new WebSocketServer({ port: 8000 });

// make it external
var inside = 0;

wss.on('connection', function connection(ws) {
  var inside = 0;
  console.log('reached')

  //the intended server
  inside = new WebSocket('ws://127.0.0.1:9000')

  console.log(inside)

  // you have to wait until the intended server is connected to to do any of the reset - nested callback
  inside.on('open', function open(){

    //send responses from the server back
    inside.on('message',function incoming(message){
      ws.send(message);
    })

    //when we get a message from the client, send it onward 
    ws.on('message', function incoming(message) {
      inside.send(message)
      console.log('forwarded: %s', message);
    });
  });
});
