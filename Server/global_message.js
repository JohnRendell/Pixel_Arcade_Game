const Fetch = require("node-fetch")
let url = "http://localhost:8080/"

module.exports = (io)=>{
    io.on("connection", (socket)=>{
        socket.on("message", async (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            let socket_data = {}

            switch(socket_type){
                case "globalMessage":
                    let msg = await checkProfanity(parsed_data.Message)
                    socket_data = {
                        Socket_Type: socket_type,
                        "Sender": parsed_data.Sender,
                        "Message": msg,
                        "Game_ID": socket.game_ID
                    }
                    console.log(socket_data)
                    
                    setTimeout(() => {
                        broadcast(io, socket_data)
                    }, 1000);
                break;
                
                case "playerConnected":
                    socket_data = {
                        Socket_Type: socket_type, 
                        "Player_ID": parsed_data.Player_ID
                    }
                    socket.game_ID = parsed_data.Player_ID

                    setTimeout(() => {
                        broadcast(io, socket_data)
                    }, 1000);
                    await setPlayerCount_status(1, io);
                break;

                case "playerDisconnected":
                    socket_data = { 
                        Socket_Type: socket_type, 
                        "Player_ID": socket.game_ID 
                    }
                    
                    setTimeout(() => {
                        broadcast(io, socket_data)
                    }, 1000);
                    await setPlayerCount_status(-1, io);
                break;
            }
        });

        socket.on("close", async (code, reason) => {
            try{
                if(socket.game_ID){
                    let socket_data = { 
                        Socket_Type: "playerDisconnected", 
                        "Player_ID": socket.game_ID 
                    }
                    setTimeout(() => {
                        broadcast(io, socket_data)
                    }, 1000);
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