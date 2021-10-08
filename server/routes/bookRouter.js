const router = require("express").Router();

const bookController = require("../controllers/bookController");

router
  .route("/")
  .get(bookController.getAllBook)
  .post(bookController.createBook);

router
  .route("/:id")
  .get(bookController.getBookById)
  .delete(bookController.deleteBook);

router.patch("/comment", bookController.addComment);

module.exports = router;
