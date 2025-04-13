const mongoose = require("mongoose");
const { Schema } = mongoose;

const gameLogs = new Schema({
    logs: { type: String, require: true },
    date: { type: Date, require: true }
});
const gameLogs_model = mongoose.model("game_logs", gameLogs);

module.exports = gameLogs_model