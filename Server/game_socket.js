module.exports = (server) =>{
    server.on("connection", (socket)=>{
        socket.on("message", (data)=>{
            console.log(JSON.parse(data));
        });
    });
}