module.exports = (server) =>{
    server.on("connection", (socket)=>{
        socket.on("message", (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            let socket_data = {};

            switch(socket_type){
                case "playerSpawn":
                    let playerName = parsed_data.Player_Name;
                    let playerCoords = { x: parsed_data.Pos_X, y: parsed_data.Pos_Y }
                    
                    socket_data = {
                        Socket_Type: socket_type,
                        "Player_Name": playerName,
                        "Pos_X": playerCoords.x,
                        "Pos_Y": playerCoords.y
                    }
                    break;
            }

            //send back the data to all players
            broadcast(server, socket_data);
        });
    });

    function broadcast(server, data) {
        server.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(data));
            }
        });
    }

}