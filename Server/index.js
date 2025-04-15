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

mongoose.connection.on("connected", () => {
    console.log("Connected to DB:", mongoose.connection.name);
});

//parse incoming json
app.use(express.json())

//serve the folders
app.use(express.static(path.join(__dirname, "../Index_Page")))
app.use("/Contents", express.static(path.join(__dirname, "../Assets")))

app.get("/", (req, res)=>{
  res.sendFile(path.join(__dirname, "../Index_Page/index.html"))
});

//for socket
const io = new WebSocket.Server({ server: expressServer });

io.on("connection", (socket)=>{
    console.log("Server Connected")

    socket.on("message", async (data)=>{
        let parsed_data = JSON.parse(data);
        
        if(parsed_data.send === "ping"){
          io.clients.forEach(client => {
              if (client.readyState === WebSocket.OPEN) {
                  client.send(JSON.stringify({ send: "pong" }));
              }
          });
        }
    })
});
require("./player_spawn_socket")(io, "lobby")
require("./global_message")(io);

//for routes
app.use("/validate", require("./validateAccount"));
app.use("/success", require("./successRedirect"));
app.use("/gameData", require("./gameDataFetching"));

app.use(bodyParser.json())

const PORT = process.env.PORT || 1000
expressServer.listen(PORT, ()=>{ console.log(`Listening to ${PORT}`) })