const mongoose = require("mongoose");

const DiscountSchema = new mongoose.Schema({
  code: {
    type: String,
    required: true,
  },
  value: {
    type: Number,
    required: true,
  },
  expiredDate: {
    type: Date,
    required: true,
  },
});

module.exports = mongoose.model("Discounts", DiscountSchema);
