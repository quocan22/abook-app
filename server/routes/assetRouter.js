const router = require("express").Router();
const upload = require("../utils/multer");

const assetController = require("../controllers/assetController");
const authentication = require("../middlewares/authentication");
const authenticationAdmin = require("../middlewares/authenticationEmployee");

router
  .route("/avatar")
  .post(upload.single("image"), authentication, assetController.uploadAvatar);

router
  .route("/book/:id")
  .put(
    upload.single("image"),
    authentication,
    authenticationAdmin,
    assetController.updateBookImage
  );

router
  .route("/avatar/:id")
  .put(upload.single("image"), authentication, assetController.updateAvatar)
  .delete(upload.single("image"), authentication, assetController.deleteAvatar);

module.exports = router;
