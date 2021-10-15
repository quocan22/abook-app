const jwt = require("jsonwebtoken");
const authentication = (req, res, next) => {
  try {
    const header = req.header("Authorization");

    const [firstEle, secondEle] = header.split(" ");

    let token;
    if (secondEle) {
      token = secondEle;
    } else {
      token = firstEle;
    }

    if (!token) {
      return res.status(401).json({ message: "Invalid authentication" });
    }

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
      if (err) {
        return res.status(401).json({ message: "Invalid authentication" });
      }
      req.user = user;
      next();
    });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

module.exports = authentication;
