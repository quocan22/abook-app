const router = require("express").Router();
const upload = require("../utils/multer");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

const userController = require("../controllers/userController");

router.get("/activate/:token", userController.activateEmail);

router.get("/address_book", userController.getAddressBooks);

router.get("/:id", userController.getUserInfo);

router.get("/", userController.getAllUser);

router.put("/:id", upload.single("image"), userController.updateInfo);

router.post("/address_book", userController.addAddress);

router.post("/register", upload.single("image"), userController.register);

router.post("/signup", userController.signup);

router.post("/change_password", userController.changePassword);

router.post("/fav/add", userController.addBookToFav);

router.post("/fav/remove", userController.removeBookFromFav);

module.exports = router;
