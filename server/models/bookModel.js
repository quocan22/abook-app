const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema(
  {
    categoryId: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    author: {
      type: String,
      required: true,
    },
    imageUrl: {
      type: String,
      default:
        "https://res.cloudinary.com/quocan/image/upload/v1634490881/abook/book/book_default_qsmm4e.jpg",
    },
    cloudinaryId: {
      type: String,
      default: "abook/book/book_default_qsmm4e",
    },
    isAvailable: {
      type: Boolean,
      default: true,
    },
    price: {
      type: Number,
      default: 0,
    },
    discountRatio: {
      type: Number,
      default: 0,
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
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Books", bookSchema);
