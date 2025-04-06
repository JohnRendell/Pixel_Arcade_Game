const express = require("express")
const route = express.Router();
const path = require("path");

route.get("/", (req, res)=>{
    res.status(200).sendFile(path.join(__dirname, "../Sign Up Pages/account_create.html"))
})

module.exports = route;