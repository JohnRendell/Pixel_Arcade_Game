module.exports = (io, socket_label) =>{
    io.on("connection", (socket)=>{
        console.log("Connected to the server: " + socket.id)
        console.log("Label: " + socket_label)
    })
}