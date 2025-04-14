const mongoose = require("mongoose");
const { Schema } = mongoose;

const gameData = new Schema({
    playerCount: { type: Number, require: true },
});
const gameData_model = mongoose.model("gameData", gameData);

module.exports = gameData_model