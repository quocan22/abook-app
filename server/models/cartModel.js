const mongoose = require("mongoose");

const cartSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  details: {
    type: Array,
    default: [],
  },
});

module.exports = mongoose.model("Carts", cartSchema);
