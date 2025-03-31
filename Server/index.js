const express = require("express");
const WebSocket = require('ws');

const app = express();
const expressServer = require("http").createServer(app)
const path = require("path");

require("dotenv").config({ path: path.resolve(__dirname, "../keys.env" )})

app.get("/", (req, res)=>{
    res.send("Hi, the server is open")
});

//for socket
const io = new WebSocket.Server({ server: expressServer });

io.on("connection", (socket)=>{
    console.log("Server Connected")
    socket.send(JSON.stringify({ message: "Hello from Express!" }));
});
require("./game_socket")(io)

const PORT = process.env.PORT || 1000
expressServer.listen(PORT, ()=>{ console.log(`Listening to ${PORT}`) })