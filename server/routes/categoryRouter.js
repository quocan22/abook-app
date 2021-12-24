const router = require("express").Router();

const categoryController = require("../controllers/categoryController");

router
  .route("/")
  .get(categoryController.getAllCategories)
  .post(categoryController.createCategory)
  .put(categoryController.updateCategory);

router.route("/:id").delete(categoryController.deleteCategory);

module.exports = router;
