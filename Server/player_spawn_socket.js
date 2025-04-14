module.exports = (server, scene_name) =>{
    server.on("connection", (socket)=>{
        socket.on("message", (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            let socket_data = {};

            switch(socket_type){
                case "playerSpawn_" + scene_name:
                    let playerName = parsed_data.Player_Name;
                    let playerCoords = { x: parsed_data.Pos_X, y: parsed_data.Pos_Y }
                    let isLeft = parsed_data.isLeft;
                    let isRight = parsed_data.isRight;
                    let isUp = parsed_data.isUp;
                    let isDown = parsed_data.isDown;
                    let isIdle = parsed_data.isIdle;
                    
                    socket_data = {
                        Socket_Type: socket_type,
                        "Player_Name": playerName,
                        "Pos_X": playerCoords.x,
                        "Pos_Y": playerCoords.y,
                        "isLeft": isLeft,
                        "isRight": isRight,
                        "isDown": isDown,
                        "isUp": isUp,
                        "isIdle": isIdle
                    }
                    break;

                case "playerLeave_" + scene_name:
                    socket_data = {
                        Socket_Type: socket_type,
                        "Player_Name": parsed_data.Player_Name
                    }
                    console.log(socket_data)
                    break;
            }

            //send back the data to all players
            broadcast(server, socket_data);
        });

        socket.on("close", (code, reason) => {
            console.log(`Player disconnected. Code: ${code}, Reason: ${reason}`);
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