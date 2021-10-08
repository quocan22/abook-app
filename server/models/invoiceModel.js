const mongoose = require("mongoose");

const invoiceSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  discountPrice: {
    type: Number,
    default: 0,
  },
  totalPrice: {
    type: Number,
    default: 0,
  },
  purchaseDate: {
    type: Date,
    default: Date.now,
  },
  details: {
    type: Array,
    default: [],
  },
});

module.exports = mongoose.model("Invoices", invoiceSchema);
