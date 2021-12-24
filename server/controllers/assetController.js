const { cloudinary } = require("../utils/cloudinary");
const Users = require("../models/userModel");
const Books = require("../models/bookModel");

const assetController = {
  uploadAvatar: async (req, res) => {
    try {
      const user = await Users.findById(req.body.id);

      // check if user exists
      if (!user) {
        return res.status(400).json({ msg: "Cannot find this user" });
      }

      // upload image to Cloudinary
      const result = await cloudinary.uploader.upload(req.file.path, {
        folder: "abook/avatar",
      });

      // save image url and image id to user
      user.userClaim.avatarUrl = result.secure_url;
      user.userClaim.cloudinaryId = result.public_id;

      await user.save();
      res.json({
        msg: "Upload image successfully",
        data: user.userClaim,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  deleteAvatar: async (req, res) => {
    try {
      const user = await Users.findById(req.params.id);

      // check if user exists
      if (!user) {
        return res.status(400).json({ msg: "Cannot find this user" });
      }

      // if image id is default, delete the image
      if (user.userClaim.cloudinaryId !== process.env.DEFAULT_PUBLIC_ID) {
        // delete image on Cloudinary
        await cloudinary.uploader.destroy(user.userClaim.cloudinaryId);
        // change avatar id and url to default
        user.userClaim.cloudinaryId = process.env.DEFAULT_PUBLIC_ID;
        user.userClaim.avatarUrl = process.env.DEFAULT_IMAGE_URL;
      }

      user.save();

      res.json({
        msg: "Delete avatar successfully",
        data: user,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateAvatar: async (req, res) => {
    try {
      const user = await Users.findById(req.params.id);

      // check if user exists
      if (!user) {
        return res.status(400).json({ msg: "Cannot find this user" });
      }

      var result;

      if (user.userClaim.cloudinaryId !== process.env.DEFAULT_PUBLIC_ID) {
        // if old avatar is not default, delete it
        await cloudinary.uploader.destroy(user.userClaim.cloudinaryId);
        // upload image to Cloudinary
        result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/avatar",
        });
      } else {
        // if old avatar is default, wait the result to be uploaded
        result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/avatar",
        });
      }

      // save new avatar url and id for user
      user.userClaim.avatarUrl = result.secure_url;
      user.userClaim.cloudinaryId = result.public_id;

      await user.save();
      res.json({
        msg: "Update image successfully",
        data: user.userClaim,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateBookImage: async (req, res) => {
    try {
      const book = await Books.findById(req.params.id);

      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "Cannot find this book" });
      }

      var result;

      if (book.cloudinaryId !== process.env.DEFAULT_BOOK_PUBLIC_ID) {
        // if old avatar is not default, delete it
        await cloudinary.uploader.destroy(book.cloudinaryId);
        // upload image to Cloudinary
        result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/book",
        });
      } else {
        // if old avatar is default, wait the result to be uploaded
        result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/book",
        });
      }

      // save new image url and id for book
      book.imageUrl = result.secure_url;
      book.cloudinaryId = result.public_id;

      await book.save();

      res.json({
        msg: "Update image successfully",
        data: book,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = assetController;
