const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      select: false,
    },
    role: {
      type: Number, // 1: user, 2: staff, 3: admin
      default: 1,
    },
    isLocked: {
      type: Boolean,
      default: false,
    },
    userClaim: {
      displayName: {
        type: String,
        default: "",
      },
      avatarUrl: {
        type: String,
        default:
          "https://res.cloudinary.com/quocan/image/upload/v1633830550/abook/avatar/anonymous_lx6zwf.png",
      },
      cloudinaryId: {
        type: String,
        default: "abook/avatar/anonymous_lx6zwf",
      },
      phoneNumber: {
        type: String,
        default: "",
      },
      address: {
        type: String,
        default: "",
      },
      favorite: [
        {
          type: String,
        },
      ],
      addressBook: {
        type: Array,
        default: [],
      },
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Users", userSchema);
