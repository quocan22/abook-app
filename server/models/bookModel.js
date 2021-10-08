const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema({
  categoryId: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  imageUrl: {
    type: String,
    default: "",
  },
  isAvailable: {
    type: Boolean,
    default: true,
  },
  price: {
    type: Number,
    required: true,
  },
  quantity: {
    type: Number,
    default: 0,
  },
  description: {
    type: String,
    default: "",
  },
  avgRate: {
    type: Number,
    default: 0,
  },
  comments: {
    type: Array,
    default: [],
  },
});

module.exports = mongoose.model("Books", bookSchema);
