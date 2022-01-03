const router = require("express").Router();
const upload = require("../utils/multer");

const categoryController = require("../controllers/categoryController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router
  .route("/")
  .get(categoryController.getAllCategories)
  .post(
    upload.single("image"),
    authentication,
    authenticationEmployee.authenticationStaff,
    categoryController.createCategory
  )
  .put(
    upload.single("image"),
    authentication,
    authenticationEmployee.authenticationStaff,
    categoryController.updateCategory
  );

router
  .route("/:id")
  .delete(
    authentication,
    authenticationEmployee.authenticationStaff,
    categoryController.deleteCategory
  );

module.exports = router;
