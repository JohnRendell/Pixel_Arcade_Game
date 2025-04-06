const express = require("express");
const WebSocket = require('ws');
const bodyParser = require('body-parser')

const app = express();
const expressServer = require("http").createServer(app)
const path = require("path");

const mongoose = require("mongoose");

require("dotenv").config({ path: path.resolve(__dirname, "../keys.env" )})

//connect to mongoose
const uri = process.env.MONGO_URI;

const clientOptions = { serverApi: { version: '1', strict: true, deprecationErrors: true } };

async function run() {
  try {
    // Create a Mongoose client with a MongoClientOptions object to set the Stable API version
    await mongoose.connect(uri, clientOptions);
    await mongoose.connection.db.admin().command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");
  } 
  catch(err){
    console.log(err)
  }
}
run().catch(console.dir);

//parse incoming json
app.use(express.json())

app.get("/", (req, res)=>{
    res.send("Hi, the server is open")
});

//for socket
const io = new WebSocket.Server({ server: expressServer });

io.on("connection", (socket)=>{
    console.log("Server Connected")
});
require("./game_socket")(io)

//for routes
app.use("/validate", require("./validateAccount"))

app.use(bodyParser.json())

const PORT = process.env.PORT || 1000
expressServer.listen(PORT, ()=>{ console.log(`Listening to ${PORT}`) })