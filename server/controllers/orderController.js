const Orders = require("../models/orderModel");
const Users = require("../models/userModel");
const Books = require("../models/bookModel");
const Carts = require("../models/cartModel");

const orderController = {
  createOrder: async (req, res) => {
    try {
      const { cartId, discountPrice, paidStatus } = req.body;

      const cart = await Carts.findById(cartId);

      if (!cart) {
        return res.status(404).json({ msg: "Cannot find this cart" });
      }

      if (cart.details.length < 1) {
        return res.status(400).json({ msg: "This cart is empty" });
      }

      var orderDetails = cart.details;
      var totalPrice = 0;

      for (let i = 0; i < cart.details.length; i++) {
        let book = await Books.findById(cart.details[i].bookId);

        // Stop ordering if book is not available
        if (!book.isAvailable) {
          return res.status(400).json({
            msg: `The book named ${book.name} is discontinued business`,
          });
        }

        let sellPrice = book.price;
        let quantity = cart.details[i].quantity;

        orderDetails[i].sellPrice = sellPrice;
        totalPrice += sellPrice * quantity;
      }

      const newOrder = Orders({
        userId: cart.userId,
        discountPrice,
        totalPrice: totalPrice - discountPrice,
        paidStatus,
        shippingStatus: 0,
        details: orderDetails,
      });

      await newOrder.save();

      // After ordering, cart have to be deleted
      await Carts.findByIdAndDelete(cartId);

      res.status(202).json({
        msg: "Create order successfully",
        data: newOrder,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAllOrdersNotDetails: async (req, res) => {
    try {
      const orders = await Orders.find().sort({ createdAt: -1 });

      if (orders.length < 1) {
        return res.status(200).json({
          msg: "Get all orders successfully",
          data: orders,
        });
      }

      var ordersRes = [];

      for (let i = 0; i < orders.length; i++) {
        ordersRes[i] = orders[i].toObject();

        let id = String(orders[i]._id);

        // Make shorted bill no of order like "abc...def" base on id
        let startStr = id.slice(0, 3);
        let endStr = id.slice(-3);
        ordersRes[i].billNo = `${startStr}...${endStr}`;

        // Get customer name and customer phone number
        let customer = await Users.findById(orders[i].userId);
        ordersRes[i].customerName = customer.userClaim.displayName;
        ordersRes[i].customerPhone = customer.userClaim.phoneNumber;

        // Get total products of order
        ordersRes[i].totalProducts = orders[i].details.length;

        // Remove unnecessary details
        delete ordersRes[i].details;
      }

      res.status(200).json({
        msg: "Get all orders successfully",
        result: ordersRes.length,
        data: ordersRes,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getOrderInfo: async (req, res) => {
    try {
      const order = await Orders.findById(req.params.id);

      if (!order) {
        return res.status(400).json({ msg: "Cannot find this order" });
      }

      var booksRes = order.details;

      for (let i = 0; i < order.details.length; i++) {
        const book = await Books.findById(order.details[i].bookId);

        const { name, imageUrl, isAvailable } = book.toObject();

        booksRes[i].name = name;
        booksRes[i].imageUrl = imageUrl;
        booksRes[i].isAvailable = isAvailable;
      }

      const user = await Users.findById(order.userId);

      const claim = user.userClaim;

      var orderRes = order.toObject();
      orderRes.details = booksRes;
      orderRes.customerName = claim.displayName;
      orderRes.customerPhone = claim.phoneNumber;
      orderRes.customerAddress = claim.address;

      res.status(200).json({
        msg: "Get order information successfully",
        data: orderRes,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateShippingStatus: async (req, res) => {
    const { id, status } = req.body;

    Orders.findByIdAndUpdate(
      id,
      { shippingStatus: status },
      function (err, result) {
        if (err) {
          res.status(400).json({ msg: err.message });
        } else {
          res.status(201).json({
            msg: "Update order shipping status successfully",
            id: result._id,
          });
        }
      }
    );
  },
};

module.exports = orderController;
