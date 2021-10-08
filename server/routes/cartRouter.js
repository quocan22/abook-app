const router = require("express").Router();

const cartController = require("../controllers/cartController");

router.route("/").post(cartController.createCart);

router.get("/user", cartController.getCartByUserId);

router.get("/details", cartController.getCartDetail);

router.patch("/addbook", cartController.addBookToCart);

router.patch("/changequantity", cartController.changeQuantity);

module.exports = router;
