const mongoose = require("mongoose");

const FeedbackSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      default: "",
    },
    content: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Feedbacks", FeedbackSchema);
