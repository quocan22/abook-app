const router = require("express").Router();

const userController = require("../controllers/userController");

router.get("/:id", userController.getUserInfo);

router.get("/", userController.getAllUser);

router.post("/register", userController.register);

router.put("/login", userController.login);

router.post("/getaccesstoken", userController.getAccessToken);

router.post("/changepassword", userController.changePassword);

router.post("/googlelogin", userController.googleLogin);

router.post("/facebooklogin", userController.facebookLogin);

module.exports = router;
