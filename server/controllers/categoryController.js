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

      await newCate.save();

      res.status(201).json({ msg: "Create category successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateCategory: async (req, res) => {
    try {
      const { id, newName } = req.body;

      Categories.findByIdAndUpdate(
        id,
        { categoryName: newName },
        function (err, result) {
          if (err) {
            res.status(400).json({ msg: err.message });
          } else {
            res
              .status(201)
              .json({ msg: "Update category successfully", id: result._id });
          }
        }
      );
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

      await Categories.findByIdAndDelete(req.params.id);

      res.status(202).json({ msg: "Deleted successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = categoryController;
