const router = require("express").Router();
const upload = require("../utils/multer");

const categoryController = require("../controllers/categoryController");
const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");

router
  .route("/")
  .get(categoryController.getAllCategories)
  .post(
    upload.single("image"),
    authentication,
    authenticationAdmin,
    categoryController.createCategory
  )
  .put(
    upload.single("image"),
    authentication,
    authenticationAdmin,
    categoryController.updateCategory
  );

router
  .route("/:id")
  .get(categoryController.getCategoryById)
  .delete(
    authentication,
    authenticationAdmin,
    categoryController.deleteCategory
  );

module.exports = router;
