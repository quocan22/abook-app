const router = require("express").Router();

const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");
const orderController = require("../controllers/orderController");

router.get("/revenue/annual", orderController.getAnnualRevenueReport);
router.get("/revenue/monthly", orderController.getMonthlyRevenueReport);

module.exports = router;
