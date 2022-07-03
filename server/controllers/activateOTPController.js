const bcrypt = require("bcrypt");

const ActivateOTPs = require("../models/activateOTPModel");
const Users = require("../models/userModel");
const emailService = require("../utils/emailService");

const activateOTPController = {
  verifyOTP: async (req, res) => {
    try {
      const { userId, otp } = req.body;

      if (!userId || !otp) {
        return res.status(422).json({ msg: "OTP code is required" });
      }

      const userOTPVerificationRecords = await ActivateOTPs.find({
        userId,
      }).sort({ createdAt: -1 });

      if (userOTPVerificationRecords.length <= 0) {
        return res.status(404).json({
          msg: "Account record does not exist or has been verified already. Please sign up or log in",
        });
      }

      const { expiresAt } = userOTPVerificationRecords[0];
      const hashedOTP = userOTPVerificationRecords[0].otp;

      if (expiresAt < Date.now()) {
        // if user otp record has expired
        await ActivateOTPs.deleteMany({ userId });
        return res
          .status(410)
          .json({ msg: "Code has expired. Please request again" });
      } else {
        const isMatchedOTP = await bcrypt.compare(otp, hashedOTP);

        if (!isMatchedOTP) {
          // if submitted OTP is wrong
          return res.status(404).json({ msg: "This OTP code is wrong" });
        }

        await Users.updateOne({ _id: userId }, { isActivated: true });
        await ActivateOTPs.deleteMany({ userId });

        res
          .status(200)
          .json({ msg: "Your account has been activate successfully" });
      }
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  resendVerifyCode: async (req, res) => {
    try {
      const { email } = req.body;

      const user = await Users.findOne({ email });

      if (!user) {
        return res.status(404).json({ msg: "This user does not exist" });
      }

      emailService.sendActivationEmail(user, res);
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = activateOTPController;
