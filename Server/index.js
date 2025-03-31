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

//TODO: fix this
io.on("connection", (socket)=>{
    io.send("Welcome to server")
})
//require("./game_socket")(socket, "test")

const PORT = process.env.PORT || 1000
expressServer.listen(PORT, ()=>{ console.log(`Listening to ${PORT}`) })