const router = require("express").Router();

const activateOTPController = require("../controllers/activateOTPController");

router.post("/verify_otp", activateOTPController.verifyOTP);

router.post("/resend_verify_code", activateOTPController.resendVerifyCode);

module.exports = router;
