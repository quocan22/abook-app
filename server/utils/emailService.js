const nodemailer = require("nodemailer");
const bcrypt = require("bcrypt");
const { google } = require("googleapis");
const { OAuth2 } = google.auth;

const ActivateOTPs = require("../models/activateOTPModel");

const OAUTH_PLAYGROUND = "https://developers.google.com/oauthplayground";

const {
  GOOGLE_API_CLIENT_ID,
  GOOGLE_API_CLIENT_SECRET,
  GOOGLE_OAUTH_REFRESH_TOKEN,
  MAIL_SERVICE_SENDER,
} = process.env;

const oAuth2Client = new OAuth2(
  GOOGLE_API_CLIENT_ID,
  GOOGLE_API_CLIENT_SECRET,
  OAUTH_PLAYGROUND
);

const emailService = {
  sendActivationEmail: async ({ _id, email }, res) => {
    try {
      oAuth2Client.setCredentials({
        refresh_token: GOOGLE_OAUTH_REFRESH_TOKEN,
      });

      const accessToken = await oAuth2Client.getAccessToken();

      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
          type: "OAuth2",
          user: MAIL_SERVICE_SENDER,
          clientId: GOOGLE_API_CLIENT_ID,
          clientSecret: GOOGLE_API_CLIENT_SECRET,
          refreshToken: GOOGLE_OAUTH_REFRESH_TOKEN,
          accessToken,
        },
      });

      const otp = `${Math.floor(1000 + Math.random() * 9000)}`;

      const mailOptions = {
        from: MAIL_SERVICE_SENDER,
        to: email,
        subject: "Verify Your ABook Account",
        html: `<body style="background-color: #f4f4f4; margin: 0 !important; padding: 0 !important;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td bgcolor="#48CAE4" align="center">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                        <tr>
                            <td align="center" valign="top" style="padding: 40px 10px 40px 10px;"> </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td bgcolor="#48CAE4" align="center" style="padding: 0px 10px 0px 10px;">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                        <tr>
                            <td bgcolor="#ffffff" align="center" valign="top" style="padding: 40px 20px 20px 20px; border-radius: 4px 4px 0px 0px; color: #111111; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 48px; font-weight: 400; letter-spacing: 4px; line-height: 48px;">
                                <h1 style="font-size: 48px; font-weight: 400; margin: 2;">Welcome to ABook!</h1> <img src="https://res.cloudinary.com/quocan/image/upload/v1637044704/abook/LogoNonBG_dopfe8.png" width="125" height="120" style="display: block; border: 0px;" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td bgcolor="#f4f4f4" align="center" style="padding: 0px 10px 0px 10px;">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                        <tr>
                            <td bgcolor="#ffffff" align="left" style="padding: 20px 30px 40px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                                <p style="margin: 0;">We're excited to have you get started. First, you need to confirm your account. This is your verification code. This code expires in 10 minutes</p>
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#ffffff" align="center"><p target="_blank" style="font-size: 30px; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #000000; letter-spacing: 10px;">${otp}</p>
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#ffffff" align="left" style="padding: 0px 30px 40px 30px; border-radius: 0px 0px 4px 4px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                                <p style="margin: 0;">Cheers,<br>ABook Team</p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
      </body>`,
      };

      // hash the otp code
      const hashedOTP = await bcrypt.hash(otp, 10);
      const newActivateOTP = await new ActivateOTPs({
        userId: _id,
        otp: hashedOTP,
        createdAt: Date.now(),
        expiresAt: Date.now() + 600000,
      });

      // save otp record
      await newActivateOTP.save();
      await transporter.sendMail(mailOptions);

      res.status(200).json({
        msg: "Verification otp email sent",
        data: {
          userId: _id,
          email,
        },
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = emailService;
