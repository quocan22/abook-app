const Carts = require("../models/cartModel");
const Users = require("../models/userModel");
const Books = require("../models/bookModel");

const cartController = {
  getCartByUserId: async (req, res) => {
    try {
      const userId = req.query.userId;

      const useCheck = await Users.findById(userId);

      // check if user exists
      if (!useCheck) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const cart = await Carts.findOne({ userId });

      // check if cart exists
      if (!cart) {
        return res.status(404).json({ msg: "This user has no cart" });
      }

      res.json({
        msg: "Get cart by userId successfully",
        data: cart,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createCart: async (req, res) => {
    try {
      const { userId } = req.body;

      const useCheck = await Users.findById(userId);

      // check if user exists
      if (!useCheck) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const cart = await Carts.findOne({ userId });

      // check if this user already had a cart
      if (cart) {
        return res.status(422).json({ msg: "This user already had cart" });
      }

      const newCart = new Carts({ userId });

      await newCart.save();

      res.status(202).json({ msg: "Create cart successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  addBookToCart: async (req, res) => {
    try {
      const userId = req.query.userId;
      const { bookId, quantity } = req.body;

      const selectedBook = await Books.findById(bookId);

      if (!selectedBook) {
        return res.status(404).json({ msg: "Cannot find this book" });
      }

      if (selectedBook.quantity < quantity) {
        return res
          .status(400)
          .json({ msg: "This book quantity is not enough" });
      }

      const userCheck = await Users.findById(userId);

      // check if user exists
      if (!userCheck) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const cart = await Carts.findOne({ userId });

      // check if cart exists
      if (!cart) {
        const newCart = new Carts({ userId });
        newCart.details.push({ bookId, quantity });

        await newCart.save();
      } else {
        const existBookIndex = cart.details.findIndex((d) => {
          return d.bookId === bookId;
        });

        if (existBookIndex === -1) {
          // push detail to array if book does not exist in cart
          cart.details.push({ bookId, quantity });
        } else {
          // add quantity if book exists in cart
          cart.details[existBookIndex].quantity += quantity;
          cart.markModified("details");
        }

        await cart.save();
      }

      res.status(200).json({ msg: "Add boook to cart successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getCartDetail: async (req, res) => {
    try {
      const userId = req.query.userId;

      const useCheck = await Users.findById(userId);

      // check if user exists
      if (!useCheck) {
        return res.status(404).json({ msg: "Cannot find this user" });
      }

      const cart = await Carts.findOne({ userId });

      // check if cart exists
      if (!cart) {
        return res.status(404).json({ msg: "Cannot find this cart" });
      }

      res.status(200).json({
        msg: "Get cart details successfully",
        result: cart.details.length,
        data: cart.details,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  changeQuantity: async (req, res) => {
    try {
      const userId = req.query.userId;
      const { bookId, newQuantity } = req.body;

      const cart = await Carts.findOne({ userId });

      // if cart exist, update corresponded book
      if (cart) {
        for (let i = 0; i < cart.details.length; i++) {
          if (cart.details[i].bookId === bookId) {
            cart.details[i].quantity = newQuantity;
            cart.markModified("details");
            await cart.save();
            break;
          }
        }

        return res.status(200).json({ msg: "Change quantity successfully" });
      }

      res.status(400).json({ msg: "Change quantity failed" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  removeBookFromCart: async (req, res) => {
    try {
      const userId = req.query.userId;
      const { bookId } = req.body;

      const cart = await Carts.findOne({ userId });

      console.log(cart.details);

      if (cart) {
        cart.details = cart.details.filter((c) => c.bookId !== bookId);

        await cart.save();

        return res
          .status(200)
          .json({ msg: "Remove book from cart successfully" });
      }

      res.status(400).json({ msg: "Remove book from cart failed" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = cartController;
