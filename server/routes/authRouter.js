const router = require("express").Router();

const userController = require("../controllers/userController");

router.post("/login", userController.login);

router.post("/admin_login", userController.adminLogin);

// router.post("/google_login", userController.googleLogin);

// router.post("/facebook_login", userController.facebookLogin);

router.post("/refresh_token", userController.refreshToken);

module.exports = router;
