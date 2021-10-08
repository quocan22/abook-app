const router = require("express").Router();

const categoryController = require("../controllers/categoryController");

router
  .route("/")
  .get(categoryController.getAllCategories)
  .post(categoryController.createCategory);

router.route("/:id").delete(categoryController.deleteCategory);

module.exports = router;
