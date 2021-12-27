const router = require("express").Router();

const discountController = require("../controllers/discountController");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

router.get("/available", discountController.getAvailableDiscounts);
router.get("/", discountController.getAllDiscounts);
router.post("/", discountController.createDiscount);
router.put("/", discountController.updateDiscount);

router.delete(
  "/:id",
  authentication,
  authenticationEmployee.authenticationStaff,
  discountController.deleteDiscount
);

module.exports = router;
