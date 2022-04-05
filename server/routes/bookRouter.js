const router = require("express").Router();
const upload = require("../utils/multer");

const bookController = require("../controllers/bookController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router.get("/comment", bookController.getComments);
router.get("/cate", bookController.getBooksByCate);
router.get("/general_info", bookController.getAllBooksGeneralInfo);
router.patch("/comment", bookController.addComment);
router.put("/comment", authentication, bookController.deleteComment);

router
  .route("/")
  .get(bookController.getAllBooks)
  .post(
    upload.single("image"),
    authentication,
    authenticationEmployee.authenticationStaff,
    bookController.createBook
  );

router
  .route("/:id")
  .get(bookController.getBookById)
  .put(upload.single("image"), bookController.updateInfo)
  .delete(
    authentication,
    authenticationEmployee.authenticationStaff,
    bookController.deleteBook
  );

module.exports = router;
