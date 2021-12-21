const jwt = require("jsonwebtoken");
const authentication = (req, res, next) => {
  try {
    const bearerHeader = req.header("Authorization");

    if (bearerHeader) {
      const bearer = bearerHeader.split(" ");
      const bearerToken = bearer[1];
      const token = bearerToken;

      jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        if (err) {
          return res.status(401).json({ message: "Invalid token" });
        }
        req.user = user;
        next();
      });
    } else {
      res.status(403).json({ message: "Forbidden" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

module.exports = authentication;
