const mongoose = require("mongoose");

const RecommendSchema = new mongoose.Schema({
  bookId: {
    type: String,
    required: true,
  },
  type: {
    type: Number,
    default: 1,
  },
});

module.exports = mongoose.model("Recommends", RecommendSchema);
