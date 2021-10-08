const mongoose = require("mongoose");

const DiscountSchema = new mongoose.Schema({
  code: {
    type: String,
    required: true,
  },
  ratio: {
    type: Number,
    required: true,
  },
  maxDiscount: {
    type: Number,
  },
  expiredDate: {
    type: Date,
    required: true,
  },
});

module.exports = mongoose.model("Discounts", DiscountSchema);
