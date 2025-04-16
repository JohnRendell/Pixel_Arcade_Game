const Fetch = require("node-fetch")
let url = "http://localhost:8080/"

module.exports = (io)=>{
    io.on("connection", (socket)=>{
        socket.on("message", async (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            
            if(socket_type === "globalMessage"){
                let msg = await checkProfanity(parsed_data.Message)
                let socket_data = {
                    Socket_Type: socket_type,
                    "Sender": parsed_data.Sender,
                    "Message": msg
                }
                broadcast(io, socket_data)
            }

            if(socket_type === "playerConnected"){
                let socket_data = {
                    Socket_Type: socket_type, 
                    "Player_Name": parsed_data.Player_Name
                }
                socket.player_name = parsed_data.Player_Name
                broadcast(io, socket_data)
                await setPlayerCount_status(1, io);
            }

            if(socket_type === "playerDisconnected"){
                let socket_data = { 
                    Socket_Type: socket_type, 
                    "Player_Name": parsed_data.Player_Name 
                }
                broadcast(io, socket_data)

                await setPlayerCount_status(-1, io);
            }
        });
        socket.on("close", async (code, reason) => {
            try{
                if(socket.player_name){
                    let socket_data = { 
                        Socket_Type: "playerDisconnected", 
                        "Player_Name": socket.player_name 
                    }
                    broadcast(io, socket_data)

                    await setPlayerCount_status(-1, io);
                }
                console.log(`Player disconnected. Code: ${code}, Reason: ${reason}`);
            }
            catch(err){
                console.log(err)
            }
        });
    });
}

async function setPlayerCount_status(count, io){
    try{
        const updatePlayerCount = await Fetch(url + "gameData/setPlayerCount", {
            method: "POST",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ playerCount: count })
        });

        const updatePlayerCount_data = await updatePlayerCount.json();

        if(updatePlayerCount_data.message === "success"){
            let socket_data = {
                Socket_Type: "playerCount", 
                "Player_Count": updatePlayerCount_data.playerCount
            }
            broadcast(io, socket_data)
        }
    } 
    
    catch(err){
        console.log(err)
    }
}

function broadcast(server, data) {
    server.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            //console.log("Sending data")
            //console.log(data)
            client.send(JSON.stringify(data));
        }
    });
}

async function checkProfanity(message){
    try{
        const { Filter } = await import('bad-words');
        const filter = new Filter();
        return filter.clean(message)
    }
    catch(err){
        console.log(err);
    }
}