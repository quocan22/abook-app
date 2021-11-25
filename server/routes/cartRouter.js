const router = require("express").Router();

const cartController = require("../controllers/cartController");

router.route("/").post(cartController.createCart);

router.get("/user", cartController.getCartByUserId);

router.get("/details", cartController.getCartDetail);

router.patch("/add_book", cartController.addBookToCart);

router.patch("/change_quantity", cartController.changeQuantity);

module.exports = router;
