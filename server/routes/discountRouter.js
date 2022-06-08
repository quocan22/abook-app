const router = require("express").Router();

const discountController = require("../controllers/discountController");
const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");

router.get(
  "/available",
  authentication,
  authenticationAdmin,
  discountController.getAvailableDiscounts
);
router.get("/", discountController.getAllDiscounts);
router.post(
  "/",
  authentication,
  authenticationAdmin,
  discountController.createDiscount
);
router.put(
  "/",
  authentication,
  authenticationAdmin,
  discountController.updateDiscount
);

router.delete(
  "/:id",
  authentication,
  authenticationAdmin,
  discountController.deleteDiscount
);

module.exports = router;
