const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const fetch = require("node-fetch");

const Users = require("../models/userModel");
const { mailService } = require("../utils/mailService");

const {
  ACTIVATE_TOKEN_SECRET,
  ACCESS_TOKEN_SECRET,
  REFRESH_TOKEN_SECRET,
  GOOGLE_SECRET,
  FACEBOOK_SECRET,
  SERVER_URL,
} = process.env;

const userController = {
  register: async (req, res) => {
    try {
      const { email, password, role, userClaim } = req.body;

      // check if miss email or password field in request
      if (!email || !password) {
        return res
          .status(422)
          .json({ message: "Please enter email and password" });
      }

      // check if email invalid
      if (!validEmail(email)) {
        return res.status(400).json({ message: "Invalid email" });
      }

      const user = await Users.findOne({ email });

      // check if this email has already registed
      if (user) {
        return res.status(403).json({ message: "This email already existed" });
      }

      const newUser = {
        email: email.toLowerCase(),
        password: password,
        role: role,
        userClaim: userClaim,
      };

      const activateToken = createActivateToken(newUser);

      const url = `${SERVER_URL}/api/users/activate?activatetoken=${activateToken}`;

      mailService.sendActivationEmail(email, url);

      res.json({
        message: "Regist successfully! Please activate your email to start.",
      });
    } catch (err) {
      return res.status(500).json({ place: "register", message: err.message });
    }
  },
  activateEmail: async (req, res) => {
    try {
      const activateToken = req.query.activatetoken;

      const user = jwt.verify(activateToken, ACTIVATE_TOKEN_SECRET);

      const { email, password, role, userClaim } = user;

      const check = await Users.findOne({ email });

      if (check) {
        return res.status(400).json({ message: "This email already existed" });
      }

      const passwordHash = await bcrypt.hash(password, 10);

      const newUser = new Users({
        email,
        password: passwordHash,
        role,
        userClaim,
      });

      await newUser.save();

      res.json({ message: "Account has been actived" });
    } catch (err) {
      return res.status(500).json({ place: "activate", message: err.message });
    }
  },
  getAccessToken: (req, res) => {
    try {
      const { refreshToken } = req.body;

      // verify the refresh token
      jwt.verify(refreshToken, REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) {
          return res.status(404).json({ message: "Verifying failed" });
        }

        // if refresh token has been verified, create a new access token
        const accessToken = createAccessToken({
          id: user._id,
          role: user.role,
        });

        res.json({ accessToken });
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  login: async (req, res) => {
    try {
      const { email, password } = req.body;

      // get user with additional field password - to verify
      const user = await Users.findOne({ email }).select("+password");

      // check if this user does not exists
      if (!user) {
        return res.status(400).json({ message: "This email does not exist" });
      }

      // compare password from request and password in database
      const passwordMatched = await bcrypt.compare(password, user.password);

      // check if password is not matched
      if (!passwordMatched) {
        return res.status(400).json({ message: "Password is incorrect" });
      }

      // create a refresh token contains id and role
      const refreshToken = createRefreshToken({
        id: user._id,
        role: user.role,
      });

      res.status(200).json({
        message: "Login successfully",
        keys: {
          refreshToken: refreshToken,
          maxAge: "21 days",
        },
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  changePassword: async (req, res) => {
    try {
      const { userId, oldPassword, newPassword } = req.body;

      const user = await Users.findById(userId).select("+password");

      if (!user) {
        return res.status(400).json({ message: "Cannot find this user" });
      }

      const isMatch = await bcrypt.compare(oldPassword, user.password);

      if (isMatch) {
        const passwordHash = await bcrypt.hash(newPassword, 10);

        await Users.findOneAndUpdate(
          { _id: userId },
          { password: passwordHash }
        );

        return res
          .status(200)
          .json({ message: "Change password successfully" });
      }

      res.status(400).json({ message: "Old password is incorrect" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  googleLogin: async (req, res) => {
    try {
      const { tokenId } = req.body;

      // get user info payload
      const { email_verified, email, name, picture } =
        await mailService.googleLogin(tokenId);

      // generate password
      const password = email + GOOGLE_SECRET;
      const passwordHash = await bcrypt.hash(password, 10);

      if (!email_verified) {
        return res.status(400).json({ message: "Email verification failed" });
      }

      const user = Users.findOne({ email }).select("+password");

      if (user) {
        // if user has already registed
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
          return res.status(500).json({ message: "Something went wrong" });
        }

        // create a refresh token contains id and role
        const refreshToken = createRefreshToken({
          id: user._id,
          role: user.role,
        });

        res.status(200).json({
          message: "Login successfully",
          keys: {
            refreshToken: refreshToken,
            maxAge: "21 days",
          },
        });
      } else {
        // if user login first time
        const userClaim = {
          displayName: name,
          avatarUrl: picture,
          cloudinaryId: "",
        };
        const role = 0;

        const newUser = new Users({
          email,
          role,
          password,
          userClaim,
        });

        await newUser.save();

        // create a refresh token contains id and role
        const refreshToken = createRefreshToken({
          id: user._id,
          role: user.role,
        });

        res.status(200).json({
          message: "Login successfully",
          keys: {
            refreshToken: refreshToken,
            maxAge: "21 days",
          },
        });
      }
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  facebookLogin: async (req, res) => {
    try {
      const { accessToken, userId } = req.body;

      // make Facebook graph URL to get data
      const graphUrl = `https://graph.facebook.com/v4.0/${userId}/?fields=id,name,email,picture&access_token=${accessToken}`;

      // get user's data from graph URL
      const data = await fetch(graphUrl)
        .then((res) => res.json())
        .then((res) => {
          return res;
        });
      const { email, name, picture } = data;

      // generate password
      const password = email + FACEBOOK_SECRET;
      const passwordHash = await bcrypt.hash(password, 10);

      const user = await Users.findOne({ email }).select("+password");

      if (user) {
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
          return res.status(400).json({ message: "Something went wrong" });
        }

        // create a refresh token contains id and role
        const refreshToken = createRefreshToken({
          id: user._id,
          role: user.role,
        });

        res.status(200).json({
          message: "Login successfully",
          keys: {
            refreshToken: refreshToken,
            maxAge: "21 days",
          },
        });
      } else {
        // if user login first time
        const userClaim = {
          displayName: name,
          avatarUrl: picture,
          cloudinaryId: "",
        };
        const role = 0;

        const newUser = new Users({
          email,
          role,
          password,
          userClaim,
        });

        await newUser.save();

        // create a refresh token contains id and role
        const refreshToken = createRefreshToken({
          id: user._id,
          role: user.role,
        });

        res.status(200).json({
          message: "Login successfully",
          keys: {
            refreshToken: refreshToken,
            maxAge: "21 days",
          },
        });
      }
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  getUserInfo: async (req, res) => {
    try {
      const user = await Users.findById(req.params.id);

      // return userclaim information
      res.json({
        message: "Get user information successfully",
        data: user.userClaim,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  getAllUser: async (req, res) => {
    try {
      const users = await Users.find();

      res.json({
        message: "Get all users successfully",
        result: users.length,
        data: users,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

const createActivateToken = (payload) => {
  // create activate token expired in 5 minutes
  // this token will be used to activate the account
  return jwt.sign(payload, ACTIVATE_TOKEN_SECRET, {
    expiresIn: "5m",
  });
};

const createAccessToken = (payload) => {
  // create access token expired in 30 minutes
  // this token will be used to authorize
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
    expiresIn: "30m",
  });
};

const createRefreshToken = (payload) => {
  // create refresh token expired in 21 days
  // this token will be used to get access token
  return jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: "21d",
  });
};

function validEmail(email) {
  // regex to check if email is valid
  const regex =
    /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;

  return regex.test(email);
}

module.exports = userController;
