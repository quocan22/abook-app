const router = require("express").Router();

const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");
const orderController = require("../controllers/orderController");

router.get("/:id", orderController.getOrderInfo);
router.get("/", orderController.getAllOrdersGeneralInfo);
router.post("/", authentication, orderController.createOrder);
router.post(
  "/shipping_status",
  authentication,
  authenticationAdmin,
  orderController.updateShippingStatus
);

module.exports = router;
