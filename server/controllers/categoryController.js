const Categories = require("../models/categoryModel");
const Books = require("../models/bookModel");

const categoryController = {
  getAllCategories: async (req, res) => {
    try {
      const cates = await Categories.find();

      res.json({
        message: "Get all categories successfully",
        result: cates.length,
        data: cates,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  createCategory: async (req, res) => {
    try {
      const { categoryName } = req.body;

      const cate = await Categories.findOne({ categoryName });

      if (cate) {
        return res
          .status(403)
          .json({ message: "This category already existed" });
      }

      const newCate = new Categories({ categoryName });

      await newCate.save();

      res.status(201).json({ message: "Creating category successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  deleteCategory: async (req, res) => {
    try {
      const bookCount = Books.find({ categoryId: req.params.id }).count();

      if (count !== 0) {
        return res
          .status(400)
          .json({ message: "Please delete all books in this category" });
      }

      await Categories.findByIdAndDelete(req.params.id);

      res.status(202).json({ message: "Deleted successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

module.exports = categoryController;
