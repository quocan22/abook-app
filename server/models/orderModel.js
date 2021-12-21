const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema(
  {
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
    paidStatus: {
      type: Number, // 1: unpaid, 2: paid
      default: 1,
    },
    shippingStatus: {
      type: Number, // 1: pending, 2: completed, 3: cancelled
      default: 1,
    },
    details: {
      type: Array,
      default: [],
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Orders", orderSchema);
