const { cloudinary } = require("../utils/cloudinary");
const Categories = require("../models/categoryModel");
const Books = require("../models/bookModel");

const categoryController = {
  getAllCategories: async (req, res) => {
    try {
      const cates = await Categories.find();

      res.json({
        msg: "Get all categories successfully",
        result: cates.length,
        data: cates,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createCategory: async (req, res) => {
    try {
      const { categoryName } = req.body;

      const cate = await Categories.findOne({ categoryName });

      // check if category exists
      if (cate) {
        return res.status(403).json({ msg: "This category already existed" });
      }

      const newCate = new Categories({ categoryName });

      // if create new category with image
      if (req.file) {
        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/category",
        });

        // set image url and image id for new category
        newCate.imageUrl = result.secure_url;
        newCate.cloudinaryId = result.public_id;
      }

      await newCate.save();

      res.status(201).json({ msg: "Create category successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateCategory: async (req, res) => {
    try {
      const { id, newName } = req.body;

      const cate = await Categories.findById(id);

      if (!cate) {
        return res.status(400).json({ msg: "Cannot find this category" });
      }

      if (req.file) {
        if (cate.cloudinaryId !== process.env.DEFAULT_CATE_PUBLIC_ID) {
          // if old image is not default, delete it
          await cloudinary.uploader.destroy(cate.cloudinaryId);
        }

        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/category",
        });

        // save new image url and cloudinary id for category
        cate.imageUrl = result.secure_url;
        cate.cloudinaryId = result.public_id;
      }

      cate.categoryName = newName;

      await cate.save();

      res
        .status(201)
        .json({ msg: "Update category successfully", id: cate._id });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  deleteCategory: async (req, res) => {
    try {
      const bookCount = await Books.find({ categoryId: req.params.id }).count();

      // if this category has any book, stop deleting
      if (bookCount !== 0) {
        return res
          .status(400)
          .json({ msg: "Please delete all books in this category" });
      }

      const cate = await Categories.findById(req.params.id);

      if (!cate) {
        return res.status(400).json({ msg: "This category does not exist" });
      }

      // if category image is not default, delete it
      if (cate.cloudinaryId !== process.env.DEFAULT_CATE_PUBLIC_ID) {
        await cloudinary.uploader.destroy(cate.cloudinaryId);
      }

      // remove category from database
      await cate.remove();

      res.status(202).json({ msg: "Delete category successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = categoryController;
