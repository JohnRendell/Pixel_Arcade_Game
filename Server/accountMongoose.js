const mongoose = require("mongoose");
const { Schema } = mongoose;

const account = new Schema({
    username: { type: String, require: true },
    password: { type: String, require: true }
});
const account_model = mongoose.model("account", account);

module.exports = account_model