const express = require("express")
const route = express.Router();
const path = require("path");

route.get("/", (req, res)=>{
    res.status(200).sendFile(path.join(__dirname, "../Index_Page/account_create.html"))
})

module.exports = route;