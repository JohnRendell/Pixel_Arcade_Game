const express = require("express");
const gameModel = require("./gameLogsMongoose");
const gameDataModel = require("./gameDataMongoose");
const sanitize = require("sanitize-html");
const router = express.Router();

router.get("/gameLogs", async (req, res) => {
    try {
        let get_data = await gameModel.find({});
        
        if (get_data.length === 0) {
            const newData = await gameModel.create({ logs: "Test", date: new Date() });
            get_data = [newData];
        }

        const dataMap = get_data.map((value) => ({
            logs: value.logs,
            date: value.date
        }));

        res.status(200).json({ message: "success", data: dataMap });
    } 
    
    catch (err) {
        console.log(err);
    }
});

router.post("/setPlayerCount", async (req, res) => {
    try {
        const gameData = await gameDataModel.findOne({});
        let newCount = gameData.playerCount + sanitize(req.body.playerCount);

        if (newCount < 0) {
            newCount = 0;
        }

        await gameDataModel.findOneAndUpdate(
            {},
            { $inc: { playerCount: sanitize(req.body.playerCount) }},
            { upsert: true, new: true },
        )
        res.status(200).json({ message: "success", playerCount: newCount });
    } 
    
    catch (err) {
        console.log(err);
    }
});

router.get("/getPlayerCount", async (req, res) => {
    try {
        let getCount = await gameDataModel.findOne({})
        
        if(getCount){
            res.status(200).json({ message: "success", playerCount: getCount.playerCount });
        }
    } 
    
    catch (err) {
        console.log(err);
    }
});

module.exports = router;