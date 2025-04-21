module.exports = (server) =>{
    server.on("connection", (socket)=>{
        socket.on("message", (data)=>{
            let parsed_data = JSON.parse(data);
            let socket_type = parsed_data.Socket_Type;
            let scene_name = parsed_data.Current_Scene || undefined

            switch(socket_type){
                case "playerSpawn_" + scene_name:
                    let playerName = parsed_data.Player_Name;
                    let playerID = parsed_data.Player_ID
                    let playerCoords = { x: parsed_data.Pos_X, y: parsed_data.Pos_Y }
                    let isLeft = parsed_data.isLeft;
                    let isRight = parsed_data.isRight;
                    let isUp = parsed_data.isUp;
                    let isDown = parsed_data.isDown;
                    let isIdle = parsed_data.isIdle;
                    let current_scene = parsed_data.Current_Scene

                    //send back the data to all players
                    broadcast(
                        server, 
                        {
                            Socket_Type: socket_type,
                            "Player_Name": playerName,
                            "Player_ID": playerID,
                            "Pos_X": playerCoords.x,
                            "Pos_Y": playerCoords.y,
                            "isLeft": isLeft,
                            "isRight": isRight,
                            "isDown": isDown,
                            "isUp": isUp,
                            "isIdle": isIdle,
                            "Current_Scene": current_scene
                        }
                    );
                    break;

                case "playerGoing":
                    console.log(parsed_data)
                    setTimeout(() => {
                        //send back the data to all players
                        broadcast(
                            server, 
                            {
                                Socket_Type: socket_type,
                                "Player_ID": socket.game_ID
                            }
                        );
                    }, 2000);
                    break;
            }
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