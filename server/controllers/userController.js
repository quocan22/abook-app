const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const Users = require("../models/userModel");

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

      // hash password by bcrypt
      const passwordHash = await bcrypt.hash(password, 10);

      const newUser = new Users({
        email: email.toLowerCase(),
        password: passwordHash,
        role,
        userClaim,
      });

      newUser
        .save()
        .then(() => {
          res.status(201).json({ message: "Create user successfully" });
        })
        .catch((err) => {
          console.log(err);
          res.status(500).json({ message: "Failed to register" });
        });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  getAccessToken: (req, res) => {
    try {
      const { refreshToken } = req.body;

      // verify the refresh token
      jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET,
        (err, user) => {
          if (err) {
            return res.status(400).json({ message: "Verifying failed" });
          }

          // if refresh token has been verified, create a new access token
          const accessToken = createAccessToken({
            id: user._id,
            role: user.role,
          });

          res.json({ accessToken });
        }
      );
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

const createAccessToken = (payload) => {
  // create access token expired in 30 minutes
  // this token will be used to authorize
  return jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: "30m",
  });
};

const createRefreshToken = (payload) => {
  // create refresh token expired in 21 days
  // this token will be used to get access token
  return jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, {
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
