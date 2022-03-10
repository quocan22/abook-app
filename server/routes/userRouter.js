const router = require("express").Router();
const upload = require("../utils/multer");
const authentication = require("../middlewares/authentication");
const authenticationEmployee = require("../middlewares/authenticationEmployee");

const userController = require("../controllers/userController");

router.get("/activate/:token", userController.activateEmail);

router.get("/address_book", authentication, userController.getAddressBooks);

router.get("/:id", userController.getUserInfo);

router.get("/", userController.getAllUser);

router.put("/:id", upload.single("image"), userController.updateInfo);

router.post("/address_book", authentication, userController.addAddress);

router.post("/register", upload.single("image"), userController.register);

router.post("/signup", userController.signup);

router.post("/change_password", authentication, userController.changePassword);

router.post("/fav/add", authentication, userController.addBookToFav);

router.post("/fav/remove", authentication, userController.removeBookFromFav);

router.post(
  "/lock",
  authentication,
  authenticationEmployee.authenticationAdmin,
  userController.changeLockStatus
);

module.exports = router;
