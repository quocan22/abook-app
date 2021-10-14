const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const Users = require("../models/userModel");

const userController = {
  register: async (req, res) => {
    try {
      const { email, password, role, userClaim } = req.body;

      if (!email || !password) {
        return res
          .status(422)
          .json({ message: "Please enter email and password" });
      }

      if (!validEmail(email)) {
        return res.status(400).json({ message: "Invalid email" });
      }

      const user = await Users.findOne({ email });

      if (user) {
        return res.status(403).json({ message: "This email already existed" });
      }

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

      jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET,
        (err, user) => {
          if (err) {
            return res.status(400).json({ message: "Verifying failed" });
          }

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

      const user = await Users.findOne({ email });

      if (!user) {
        return res.status(400).json({ message: "This email does not exist" });
      }

      const passwordMatched = await bcrypt.compare(password, user.password);

      if (!passwordMatched) {
        return res.status(400).json({ message: "Password is incorrect" });
      }

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
      const user = await Users.findById(req.params.id).select("-password");

      res.json({
        message: "Get user information successfully",
        user: user,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

const createAccessToken = (payload) => {
  return jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: "30m",
  });
};

const createRefreshToken = (payload) => {
  return jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, {
    expiresIn: "21d",
  });
};

function validEmail(email) {
  const regex =
    /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;

  return regex.test(email);
}

module.exports = userController;
