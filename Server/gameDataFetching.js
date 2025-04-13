const express = require("express");
const gameModel = require("./gameLogsMongoose")
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

module.exports = router;