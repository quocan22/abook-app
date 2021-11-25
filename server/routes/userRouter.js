const router = require("express").Router();

const userController = require("../controllers/userController");

router.get("/activate", userController.activateEmail);

router.get("/:id", userController.getUserInfo);

router.get("/", userController.getAllUser);

router.post("/register", userController.register);

router.post("/change_password", userController.changePassword);

module.exports = router;
