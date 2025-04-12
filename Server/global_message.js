module.exports = (io)=>{
    io.on("connection", (socket)=>{
        socket.on("message", async (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            
            if(socket_type === "globalMessage"){
                let socket_data = {
                    Socket_Type: socket_type,
                    "Sender": parsed_data.Sender,
                    "Message": await checkProfanity(parsed_data.Message)
                }
                
                io.clients.forEach(client => {
                    if (client.readyState === WebSocket.OPEN) {
                        client.send(JSON.stringify(socket_data));
                    }
                });
            }
        })
    })
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