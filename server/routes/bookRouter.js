const router = require("express").Router();
const upload = require("../utils/multer");

const bookController = require("../controllers/bookController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router
  .route("/")
  .get(bookController.getAllBook)
  .post(
    upload.single("image"),
    authentication,
    authenticationEmployee.authenticationStaff,
    bookController.createBook
  );

router
  .route("/:id")
  .get(bookController.getBookById)
  .delete(
    authentication,
    authenticationEmployee.authenticationStaff,
    bookController.deleteBook
  );

router.patch("/comment", authentication, bookController.addComment);

module.exports = router;
