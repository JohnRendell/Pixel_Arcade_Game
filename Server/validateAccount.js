const express = require("express");
const route = express.Router();
const bcrypt = require("bcryptjs");
const account_model = require("./accountMongoose");
const sanitize = require("sanitize-html");
const badWords = require("badwords-list");

route.post("/login", async (req, res)=>{
    try{
        const find_user = await account_model.findOne({ username: sanitize(req.body.username)});
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

route.post("/signup", async (req, res)=>{
    try{
        let username = sanitize(req.body.username);
        let password = sanitize(req.body.password);
        let badWords_reg = new RegExp(badWords.array.join("|"), "i");
        const find_user = await account_model.findOne({ username: username});
        let status = "";

        if(find_user){
            status = "username already exist"
        }
        else if(badWords_reg.test(username)){
            status = "username contain bad words."
        }
        else{
            function hash_pass(pass){
                const salt = bcrypt.genSaltSync(10);
                const hash = bcrypt.hashSync(pass, salt);

                return hash
            }
            account_model.create({ username: username, password: hash_pass(password)})
            status = "success"
        }
        res.status(200).json({ message: status })
        
    }
    catch(err){
        console.log(err)
    }
});

module.exports = route