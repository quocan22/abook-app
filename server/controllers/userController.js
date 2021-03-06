const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const fetch = require("node-fetch");

const { cloudinary } = require("../utils/cloudinary");
const Users = require("../models/userModel");
const emailService = require("../utils/emailService");

const { ACTIVATE_TOKEN_SECRET, ACCESS_TOKEN_SECRET, REFRESH_TOKEN_SECRET } =
  process.env;

const userController = {
  register: async (req, res) => {
    try {
      let { email, password, role, userClaim } = req.body;

      email = email.trim();
      password = password.trim();

      // check if miss email or password field in request
      if (!email || !password) {
        return res.status(422).json({ msg: "Email and password are required" });
      }

      // check if email invalid
      if (!validEmail(email)) {
        return res.status(400).json({ msg: "Invalid email" });
      }

      const user = await Users.findOne({ email });

      // check if this email has already registered
      if (user) {
        return res.status(403).json({ msg: "This email already existed" });
      }

      const passwordHash = await bcrypt.hash(password, 10);

      const newUser = new Users({
        email: email.toLowerCase(),
        password: passwordHash,
        role: role,
        userClaim: userClaim,
        isActivated: true,
      });

      if (req.file) {
        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/avatar",
        });

        // save image url and image id to user
        newUser.userClaim.avatarUrl = result.secure_url;
        newUser.userClaim.cloudinaryId = result.public_id;
      }

      await newUser.save();

      res.status(200).json({
        msg: "Register successfully!",
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  signup: async (req, res) => {
    try {
      let { email, password, userClaim } = req.body;

      email = email.trim();
      password = password.trim();

      // check if miss email or password field in request
      if (!email || !password) {
        return res.status(422).json({ msg: "Please enter email and password" });
      }

      // check if email invalid
      if (!validEmail(email)) {
        return res.status(400).json({ msg: "Invalid email" });
      }

      const user = await Users.findOne({ email });

      // check if this email has already registered
      if (user) {
        return res.status(402).json({ msg: "This email already existed" });
      }

      const passwordHash = await bcrypt.hash(password, 10);

      const newUser = new Users({
        email: email.toLowerCase(),
        password: passwordHash,
        role: 1,
        userClaim: userClaim,
        isActivated: false,
      });

      newUser
        .save()
        .then((result) => {
          // handle account verification
          emailService.sendActivationEmail(result, res);
        })
        .catch((err) => {
          res.status(500).json({ msg: err.message });
        });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  // activateEmail: async (req, res) => {
  //   try {
  //     const token = req.params;

  //     const user = jwt.verify(token, ACTIVATE_TOKEN_SECRET);

  //     const { email, password, role, userClaim } = user;

  //     const check = await Users.findOne({ email });

  //     if (check) {
  //       return res.status(400).json({ msg: "This email already existed" });
  //     }

  //     const passwordHash = await bcrypt.hash(password, 10);

  //     const newUser = new Users({
  //       email,
  //       password: passwordHash,
  //       role,
  //       userClaim,
  //     });

  //     await newUser.save();

  //     res.json({ msg: "Account has been activated" });
  //   } catch (err) {
  //     return res.status(500).json({ msg: err.message });
  //   }
  // },
  refreshToken: (req, res) => {
    try {
      const { refreshToken } = req.body;

      // verify the refresh token
      jwt.verify(refreshToken, REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) {
          return res
            .status(404)
            .json({ msg: "Login session is expired, please login again" });
        }

        // if refresh token has been verified, create a new access token
        const accessToken = createAccessToken({
          id: user._id,
          role: user.role,
        });

        res.json({ accessToken });
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  login: async (req, res) => {
    try {
      const { email, password } = req.body;

      // get user with additional field password - to verify
      const user = await Users.findOne({ email }).select("+password");

      // check if this user does not exists
      if (!user) {
        return res.status(404).json({ msg: "This email does not exist" });
      }

      if (user.isLocked) {
        return res.status(401).json({ msg: "This user has been locked" });
      }

      if (!user.isActivated) {
        return res.status(403).json({
          msg: "This user has not been activated",
          data: {
            email: user.email,
            userId: user._id,
          },
        });
      }

      // compare password from request and password in database
      const passwordMatched = await bcrypt.compare(password, user.password);

      // check if password is not matched
      if (!passwordMatched) {
        return res.status(400).json({ msg: "Password is incorrect" });
      }

      // create a refresh token contains id and role
      const refreshToken = createRefreshToken({
        id: user._id,
        role: user.role,
      });

      // create an access token contains id and role
      const accessToken = createAccessToken({
        id: user._id,
        role: user.role,
      });

      res.status(200).json({
        msg: "Login successfully",
        data: {
          refreshToken,
          accessToken,
          id: user._id,
          email: user.email,
          role: user.role,
          displayName: user.userClaim.displayName,
          avatarUrl: user.userClaim.avatarUrl,
        },
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  adminLogin: async (req, res) => {
    try {
      const { email, password } = req.body;

      // get user with additional field password - to verify
      const user = await Users.findOne({ email }).select("+password");

      // check if this user does not exists
      if (!user) {
        return res.status(404).json({ msg: "This email does not exist" });
      }

      if (user.isLocked) {
        return res.status(401).json({ msg: "This user has been locked" });
      }

      // compare password from request and password in database
      const passwordMatched = await bcrypt.compare(password, user.password);

      // check if password is not matched
      if (!passwordMatched) {
        return res.status(400).json({ msg: "Password is incorrect" });
      }

      // block the access if the user is not admin
      if (user.role !== 2) {
        return res.status(403).json({ msg: "This user has no access" });
      }

      // create a refresh token contains id and role
      const refreshToken = createRefreshToken({
        id: user._id,
        role: user.role,
      });

      // create an access token contains id and role
      const accessToken = createAccessToken({
        id: user._id,
        role: user.role,
      });

      res.status(200).json({
        msg: "Login successfully",
        data: {
          refreshToken,
          accessToken,
          id: user._id,
          email: user.email,
          role: user.role,
          displayName: user.userClaim.displayName,
          avatarUrl: user.userClaim.avatarUrl,
        },
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateInfo: async (req, res) => {
    try {
      const { displayName, phoneNumber, address } = req.body;

      const user = await Users.findById(req.params.id);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      if (req.file) {
        if (user.userClaim.cloudinaryId !== process.env.DEFAULT_PUBLIC_ID) {
          // if old avatar is not default, delete it
          await cloudinary.uploader.destroy(user.userClaim.cloudinaryId);
        }

        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/avatar",
        });

        // save new avatar url and id for user
        user.userClaim.avatarUrl = result.secure_url;
        user.userClaim.cloudinaryId = result.public_id;
      }

      if (displayName) user.userClaim.displayName = displayName;
      if (phoneNumber) user.userClaim.phoneNumber = phoneNumber;
      if (address) user.userClaim.address = address;

      await user.save();

      res.json({
        msg: "Update user information successfully",
        data: user,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  changePassword: async (req, res) => {
    try {
      const { userId, oldPassword, newPassword } = req.body;

      const user = await Users.findById(userId).select("+password");

      if (!user) {
        return res.status(400).json({ msg: "Cannot find this user" });
      }

      const isMatch = await bcrypt.compare(oldPassword, user.password);

      if (isMatch) {
        const passwordHash = await bcrypt.hash(newPassword, 10);

        await Users.findOneAndUpdate(
          { _id: userId },
          { password: passwordHash }
        );

        return res.status(200).json({ msg: "Change password successfully" });
      }

      res.status(400).json({ msg: "Old password is incorrect" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  // googleLogin: async (req, res) => {
  //   try {
  //     const { tokenId } = req.body;

  //     // get user info payload
  //     const { email_verified, email, name, picture } =
  //       await mailService.googleLogin(tokenId);

  //     // generate password
  //     const password = email + GOOGLE_SECRET;
  //     const passwordHash = await bcrypt.hash(password, 10);

  //     if (!email_verified) {
  //       return res.status(400).json({ msg: "Email verification failed" });
  //     }

  //     const user = Users.findOne({ email }).select("+password");

  //     if (user) {
  //       // if user has already registered
  //       const isMatch = await bcrypt.compare(password, user.password);

  //       if (!isMatch) {
  //         return res.status(500).json({ msg: "Something went wrong" });
  //       }

  //       // create a refresh token contains id and role
  //       const refreshToken = createRefreshToken({
  //         id: user._id,
  //         role: user.role,
  //       });

  //       res.status(200).json({
  //         msg: "Login successfully",
  //         keys: {
  //           refreshToken,
  //           maxAge: "21 days",
  //         },
  //       });
  //     } else {
  //       // if user login first time
  //       const userClaim = {
  //         displayName: name,
  //         avatarUrl: picture,
  //         cloudinaryId: "",
  //       };
  //       const role = 0;

  //       const newUser = new Users({
  //         email,
  //         role,
  //         passwordHash,
  //         userClaim,
  //       });

  //       await newUser.save();

  //       // create a refresh token contains id and role
  //       const refreshToken = createRefreshToken({
  //         id: user._id,
  //         role: user.role,
  //       });

  //       res.status(200).json({
  //         msg: "Login successfully",
  //         keys: {
  //           refreshToken,
  //           maxAge: "21 days",
  //         },
  //       });
  //     }
  //   } catch (err) {
  //     return res.status(500).json({ msg: err.message });
  //   }
  // },
  // facebookLogin: async (req, res) => {
  //   try {
  //     const { accessToken, userId } = req.body;

  //     // make Facebook graph URL to get data
  //     const graphUrl = `https://graph.facebook.com/v4.0/${userId}/?fields=id,name,email,picture&access_token=${accessToken}`;

  //     // get user's data from graph URL
  //     const data = await fetch(graphUrl)
  //       .then((res) => res.json())
  //       .then((res) => {
  //         return res;
  //       });
  //     const { email, name, picture } = data;

  //     // generate password
  //     const password = email + FACEBOOK_SECRET;
  //     const passwordHash = await bcrypt.hash(password, 10);

  //     const user = await Users.findOne({ email }).select("+password");

  //     if (user) {
  //       const isMatch = await bcrypt.compare(password, user.password);

  //       if (!isMatch) {
  //         return res.status(400).json({ msg: "Something went wrong" });
  //       }

  //       // create a refresh token contains id and role
  //       const refreshToken = createRefreshToken({
  //         id: user._id,
  //         role: user.role,
  //       });

  //       res.status(200).json({
  //         msg: "Login successfully",
  //         keys: {
  //           refreshToken: refreshToken,
  //           maxAge: "21 days",
  //         },
  //       });
  //     } else {
  //       // if user login first time
  //       const userClaim = {
  //         displayName: name,
  //         avatarUrl: picture,
  //         cloudinaryId: "",
  //       };
  //       const role = 0;

  //       const newUser = new Users({
  //         email,
  //         role,
  //         passwordHash,
  //         userClaim,
  //       });

  //       await newUser.save();

  //       // create a refresh token contains id and role
  //       const refreshToken = createRefreshToken({
  //         id: user._id,
  //         role: user.role,
  //       });

  //       res.status(200).json({
  //         msg: "Login successfully",
  //         keys: {
  //           refreshToken: refreshToken,
  //           maxAge: "21 days",
  //         },
  //       });
  //     }
  //   } catch (err) {
  //     return res.status(500).json({ msg: err.message });
  //   }
  // },
  getUserInfo: async (req, res) => {
    try {
      const user = await Users.findById(req.params.id);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      // return user claim information
      res.json({
        msg: "Get user information successfully",
        data: {
          email: user.email,
          ...user.userClaim,
        },
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAllUser: async (req, res) => {
    try {
      const users = await Users.find();

      res.json({
        msg: "Get all users successfully",
        result: users.length,
        users,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  addAddress: async (req, res) => {
    try {
      const { userId, fullName, phoneNumber, address } = req.body;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const addressBook = {
        fullName,
        phoneNumber,
        address,
      };

      user.userClaim.addressBook.push(addressBook);

      await user.save();

      res.json({
        msg: "Add address to address book successfully",
        data: addressBook,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateAddressBook: async (req, res) => {
    try {
      const { userId, address } = req.body;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      user.userClaim.addressBook = address;

      await user.save();

      res.json({
        msg: "Update address book successfully",
        data: address,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAddressBook: async (req, res) => {
    try {
      const userId = req.params.id;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      res.json({
        msg: "Get address book successfully",
        data: user.userClaim.addressBook,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  addBookToFav: async (req, res) => {
    try {
      const { userId, bookId } = req.body;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      if (user.userClaim.favorite.includes(bookId)) {
        return res
          .status(400)
          .json({ msg: "This book has already been in favorite list" });
      }

      user.userClaim.favorite.push(bookId);

      await user.save();

      res.json({
        msg: "Add book to favorite successfully",
        data: user,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  removeBookFromFav: async (req, res) => {
    try {
      const { userId, bookId } = req.body;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const result = user.userClaim.favorite.filter((b) => b !== bookId);

      user.userClaim.favorite = result;

      await user.save();

      res.json({
        msg: "Remove book from favorite successfully",
        data: user,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  changeLockStatus: async (req, res) => {
    try {
      const { userId, status } = req.body;

      const user = await Users.findById(userId);

      if (!user) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      if (user.role === 3) {
        return res.status(400).json({ msg: "Cannot lock admin account" });
      }

      user.isLocked = status;

      await user.save();

      res.status(200).json({ msg: "Lock status updated" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
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
  // regex for checking if email is valid
  const regex =
    /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;

  return regex.test(email);
}

module.exports = userController;
