const express = require("express");
const route = express.Router();
const bcrypt = require("bcryptjs");
const account_model = require("./accountMongoose");
const sanitize = require("sanitize-html");

route.post("/login", async (req, res)=>{
    try{
        const find_user = await account_model.findOne({ username: sanitize(req.body.username )});
        let status = ""

        if(find_user){
            if(bcrypt.compareSync(sanitize(req.body.password), find_user.password)){
                status = "account exists";
            }
            else{
                status = "username or password incorrect";
            }
        }
        else{
            status = "username or password incorrect";
        }

        console.log(status)
        res.status(200).json({ message: "success", status: status })
        
    }
    catch(err){
        console.log(err)
    }
});

module.exports = route