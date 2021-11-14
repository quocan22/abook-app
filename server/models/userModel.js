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
      type: Number, //0: user, 1: staff, 2: admin
      default: 0,
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
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Users", userSchema);
