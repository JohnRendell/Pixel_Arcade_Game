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
                broadcast(io, socket_data)
            }

            if(socket_type === "playerDisconnect"){
                let socket_data = { 
                    Socket_Type: socket_type, 
                    "Player_Name": parsed_data.Player_Name 
                }
                broadcast(io, socket_data)
            }

            if(socket_type === "playerCount"){
                let socket_data = {
                    Socket_Type: socket_type, 
                    "Player_Count": parsed_data.Player_Count 
                }
                broadcast(io, socket_data)
            }
        })
    })
}

function broadcast(server, data) {
    server.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            console.log("Sending data")
            console.log(data)
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