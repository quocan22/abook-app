const router = require("express").Router();

const bookReceiptController = require("../controllers/bookReceiptController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router.post("/", bookReceiptController.receiveBooks);

module.exports = router;
