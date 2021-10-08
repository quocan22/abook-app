const bcrypt = require("bcrypt");

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

      const user = await Users.findOne({ email });

      if (user) {
        return res.status(403).json({ message: "This email already existed" });
      }

      const passwordHash = await bcrypt.hash(password, 10);

      const newUser = new Users({
        email,
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

      res.status(200).json({ message: "Login successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

module.exports = userController;
