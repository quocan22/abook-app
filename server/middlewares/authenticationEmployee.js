const authenticationEmployee = {
  authenticationStaff: (req, res, next) => {
    try {
      if (req.user.role !== 2 && req.user.role !== 3) {
        return res.status(403).json({ message: "Forbidden" });
      }
      next();
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  authenticationAdmin: (req, res, next) => {
    try {
      if (req.user.role !== 3) {
        return res.status(403).json({ message: "Forbidden" });
      }
      next();
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

module.exports = authenticationEmployee;
