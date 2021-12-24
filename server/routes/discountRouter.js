const router = require("express").Router();

const discountController = require("../controllers/discountController");

router.get("/available", discountController.getAvailableDiscounts);
router.get("/", discountController.getAllDiscounts);
router.post("/", discountController.createDiscount);
router.put("/", discountController.updateDiscount);

module.exports = router;
