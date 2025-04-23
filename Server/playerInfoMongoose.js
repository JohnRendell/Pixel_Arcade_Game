const mongoose = require("mongoose");
const { Schema } = mongoose;

const playerInfo = new Schema({
    username: { type: String, require: true },
    profile: { type: String, require: true },
    inGameName: { type: String, require: true },
    diamond: { type: Number, require: true }
});
const playerInfo_model = mongoose.model("playerInfo", playerInfo);

module.exports = playerInfo_model