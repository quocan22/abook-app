const router = require("express").Router();

const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");
const orderController = require("../controllers/orderController");
const bookReceiptController = require("../controllers/bookReceiptController");

router.get("/revenue/annual", orderController.getAnnualRevenueReport);
router.get("/revenue/monthly", orderController.getMonthlyRevenueReport);

router.get("/book_issue/annual", orderController.getAnnualBookIssueReport);
router.get("/book_issue/monthly", orderController.getMonthlyBookIssueReport);

router.get(
  "/book_receipt/annual",
  bookReceiptController.getAnnualBookReceiptReport
);
router.get(
  "/book_receipt/monthly",
  bookReceiptController.getMonthlyBookReceiptReport
);

module.exports = router;
