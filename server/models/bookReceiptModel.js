const mongoose = require("mongoose");

const bookReceiptSchema = new mongoose.Schema({
  receiptDate: {
    type: Date,
    default: Date.now,
  },
  totalPrice: {
    type: Number,
    default: 0,
  },
  details: {
    type: Array,
    default: [],
  },
});

module.exports = mongoose.model("BookReceipts", bookReceiptSchema);
