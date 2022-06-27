const router = require("express").Router();
const upload = require("../utils/multer");
const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");

const userController = require("../controllers/userController");

// router.get("/activate/:token", userController.activateEmail);

router.get("/address_book/:id", userController.getAddressBook);

router.get("/:id", userController.getUserInfo);

router.get("/", userController.getAllUser);

router.put("/:id", upload.single("image"), userController.updateInfo);

router.post("/add_address_book", userController.addAddress);

router.post("/update_address_book", userController.updateAddressBook);

router.post("/register", upload.single("image"), userController.register);

router.post("/signup", userController.signup);

router.post("/change_password", authentication, userController.changePassword);

router.post("/fav/add", userController.addBookToFav);

router.post("/fav/remove", userController.removeBookFromFav);

router.post(
  "/lock",
  authentication,
  authenticationAdmin,
  userController.changeLockStatus
);

module.exports = router;
