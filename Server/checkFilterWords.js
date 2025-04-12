const express = require("express");
const route = express.Router();

route.post("/", async (req, res)=>{
     try{
        const { Filter } = await import('bad-words');
        const filter = new Filter();
        
        res.status(200).json({ status: "success", filterWords: filter.clean(req.body.message) })
    }
    catch(err){
        console.log(err);
    }
});

module.exports = route