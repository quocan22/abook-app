const router = require("express").Router();

const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");
const orderController = require("../controllers/orderController");

router.get("/:id", orderController.getOrderInfo);
router.get("/", orderController.getAllOrdersGeneralInfo);
router.post("/", orderController.createOrder);
router.post(
  "/shipping_status",
  authentication,
  authenticationAdmin,
  orderController.updateShippingStatus
);
router.post("/paid_status", orderController.updatePaidStatus);
router.post("/get_by_user_id", orderController.getOrderByUserId);

module.exports = router;
