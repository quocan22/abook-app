const router = require("express").Router();

const discountController = require("../controllers/discountController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router.get(
  "/available",
  authentication,
  authenticationEmployee.authenticationStaff,
  discountController.getAvailableDiscounts
);
router.get("/", discountController.getAllDiscounts);
router.post(
  "/",
  authentication,
  authenticationEmployee.authenticationStaff,
  discountController.createDiscount
);
router.put(
  "/",
  authentication,
  authenticationEmployee.authenticationStaff,
  discountController.updateDiscount
);

router.delete(
  "/:id",
  authentication,
  authenticationEmployee.authenticationStaff,
  discountController.deleteDiscount
);

module.exports = router;
