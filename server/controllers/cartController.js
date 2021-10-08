const Carts = require("../models/cartModel");
const Users = require("../models/userModel");

const cartController = {
  getCartByUserId: async (req, res) => {
    try {
      const userId = req.query.userId;

      const useCheck = await Users.findById(userId);

      if (!useCheck) {
        return res.status(404).json({ message: "Cannot found this user" });
      }

      const cart = await Carts.findOne({ userId });

      if (!cart) {
        return res.status(404).json({ message: "This user has no cart" });
      }

      res.json({
        message: "Get cart by userId successfully",
        data: cart,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  createCart: async (req, res) => {
    try {
      const { userId } = req.body;

      const useCheck = await Users.findById(userId);

      if (!useCheck) {
        return res.status(404).json({ message: "Cannot found this user" });
      }

      const cart = await Carts.findOne({ userId });

      if (cart) {
        return res.status(422).json({ message: "This user already had cart" });
      }

      const newCart = new Carts({ userId });

      await newCart.save();

      res.status(202).json({ message: "Creating cart successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  addBookToCart: async (req, res) => {
    try {
      const userId = req.query.userId;
      const { bookId, quantity } = req.body;

      const useCheck = await Users.findById(userId);

      if (!useCheck) {
        return res.status(404).json({ message: "Cannot found this user" });
      }

      const cart = await Carts.findOne({ userId });

      if (!cart) {
        return res.status(404).json({ message: "Cannot found this cart" });
      }

      const newDetail = {
        bookId,
        quantity,
      };

      cart.details.push(newDetail);

      await cart.save();

      res.status(200).json({ message: "Add boook to cart successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  getCartDetail: async (req, res) => {
    try {
      const userId = req.query.userId;

      const useCheck = await Users.findById(userId);

      if (!useCheck) {
        return res.status(404).json({ message: "Cannot found this user" });
      }

      const cart = await Carts.findOne({ userId });

      if (!cart) {
        return res.status(404).json({ message: "Cannot found this cart" });
      }

      res.status(200).json({
        message: "Get cart details successfully",
        result: cart.details.length,
        data: cart.details,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  changeQuantity: async (req, res) => {
    try {
      const userId = req.query.userId;
      const { bookId, newQuantity } = req.body;

      const cart = await Carts.findOne({ userId });

      if (cart) {
        for (var i = 0; i < cart.details.length; i++) {
          if (cart.details[i].bookId === bookId) {
            cart.details[i].quantity = newQuantity;
            cart.markModified("details");
            await cart.save();
            break;
          }
        }

        return res
          .status(200)
          .json({ message: "Change quantity successfully" });
      }

      res.status(400).json({ message: "Change quantity failed" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

module.exports = cartController;
