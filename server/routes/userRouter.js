const router = require("express").Router();

const userController = require("../controllers/userController");

router.post("/register", userController.register);

router.put("/login", userController.login);

router.post("/getaccesstoken", userController.getAccessToken);

module.exports = router;
