const express = require("express");
const router = express.Router();
const playerInfo_model = require("./playerInfoMongoose");

router.post("/", async (req, res)=>{
    try{
        const findUser = await playerInfo_model.findOne({ username: req.body.username });
        let inGameName = "";
        let diamond = 0;

        if(findUser){
            inGameName = findUser.inGameName;
            diamond = findUser.diamond;
        }
        else{
            inGameName = "Cannot Get InGameName";
        }
        res.status(200).json({ inGameName: inGameName, diamondCount: diamond });
    }
    catch(err){
        console.log(err);
    }
});

module.exports = router;