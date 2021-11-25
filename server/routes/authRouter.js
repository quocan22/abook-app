const router = require("express").Router();

const userController = require("../controllers/userController");

router.put("/login", userController.login);

router.post("/google_login", userController.googleLogin);

router.post("/facebook_login", userController.facebookLogin);

router.post("/refresh_token", userController.refreshToken);

module.exports = router;
