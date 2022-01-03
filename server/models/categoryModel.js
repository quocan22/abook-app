const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema({
  categoryName: {
    type: String,
    required: true,
  },
  imageUrl: {
    type: String,
    default:
      "https://res.cloudinary.com/quocan/image/upload/v1640849284/abook/category/category_default_bwazog.png",
  },
  cloudinaryId: {
    type: String,
    default: "abook/category/category_default_bwazog",
  },
});

module.exports = mongoose.model("Categories", categorySchema);
