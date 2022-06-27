const Orders = require("../models/orderModel");
const Users = require("../models/userModel");
const Books = require("../models/bookModel");
const Carts = require("../models/cartModel");
const dateTimeFunc = require("../utils/dateTimeFunc");

const orderController = {
  createOrder: async (req, res) => {
    try {
      const { userId, discountPrice, address } = req.body;

      const cart = await Carts.find({ userId: userId });

      if (!cart) {
        return res.status(404).json({ msg: "This user has no cart" });
      }

      if (cart.details.length < 1) {
        return res.status(400).json({ msg: "This cart is empty" });
      }

      let orderDetails = cart.details;
      let totalPrice = 0;

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
        customerName: address.fullName,
        customerPhoneNumber: address.phoneNumber,
        customerAddress: address.address,
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
  getAllOrdersGeneralInfo: async (req, res) => {
    try {
      const orders = await Orders.find().sort({ createdAt: -1 });

      if (orders.length < 1) {
        return res.status(200).json({
          msg: "Get all orders successfully",
          data: orders,
        });
      }

      let ordersRes = [];

      for (let i = 0; i < orders.length; i++) {
        ordersRes[i] = orders[i].toObject();

        let id = String(orders[i]._id);

        // Make shorted bill no of order like "abc...def" base on id
        let startStr = id.slice(0, 3);
        let endStr = id.slice(-3);
        ordersRes[i].billNo = `${startStr}...${endStr}`;

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

      let booksRes = order.details;

      for (let i = 0; i < order.details.length; i++) {
        const book = await Books.findById(order.details[i].bookId);

        const { name, imageUrl, price, isAvailable } = book.toObject();

        booksRes[i].name = name;
        booksRes[i].imageUrl = imageUrl;
        booksRes[i].price = price;
        booksRes[i].isAvailable = isAvailable;
      }

      res.status(200).json({
        msg: "Get order information successfully",
        data: order,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getOrderByUserId: async (req, res) => {
    try {
      const { userId } = req.body;

      const orders = await Orders.find({ userId: userId });

      if (!orders) {
        return res.status(400).json({ msg: "Cannot find this order" });
      }

      for (let i = 0; i < orders.length; i++) {
        let booksRes = orders[i].details;

        for (let k = 0; k < orders[i].details.length; k++) {
          const book = await Books.findById(orders[i].details[k].bookId);

          const { name, imageUrl, price, isAvailable } = book.toObject();

          booksRes[k].name = name;
          booksRes[k].imageUrl = imageUrl;
          booksRes[k].price = price;
          booksRes[k].isAvailable = isAvailable;
        }
      }

      res.status(200).json({
        msg: "Get order by user id successfully",
        data: orders,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateShippingStatus: async (req, res) => {
    try {
      const { id, status } = req.body;

      const order = Orders.findById(id);

      if (!order) {
        return res.status(400).json({ msg: "Cannot find this order" });
      }

      order.shippingStatus = status;

      if (status === 2) {
        for (let i = 0; i < order.details.length; i++) {
          let result = await deliveredBook(
            order.details[i].bookId,
            order.details[i].quantity
          );

          if (result === false) {
            return res.status(400).json({
              msg: "Something went wrong",
            });
          }
        }
      }

      await order.save();

      res.status(201).json({
        msg: "Update order shipping status successfully",
        id: result._id,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAnnualRevenueReport: async (req, res) => {
    try {
      const year = req.query.y;

      if (!dateTimeFunc.validYear(year)) {
        return res.status(400).json({ msg: "Invalid year" });
      }

      // initializing 1st Jan that year and 1st Jan the next year
      const from = new Date(year, 0, 1);
      const to = new Date(parseInt(year) + 1, 0, 1);

      const orderInYear = await Orders.find({
        purchaseDate: {
          $gte: from,
          $lt: to,
        },
      });

      let result = [];

      // initializing an array with 12 elements represent for 12 months in a year
      for (let i = 0; i < 12; i++) {
        result.push({ revenue: 0, order: 0 });
      }

      orderInYear.forEach((order) => {
        if (order.paidStatus === 2) {
          // getMonth() in javascript starts at 0, so it equals to the index of array
          result[order.purchaseDate.getMonth()].revenue += order.totalPrice;
          result[order.purchaseDate.getMonth()].order++;
        }
      });

      res.status(201).json({
        msg: "Get annual revenue report successfully",
        data: result,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getMonthlyRevenueReport: async (req, res) => {
    try {
      const month = req.query.m;
      const year = req.query.y;

      if (!dateTimeFunc.validMonth(month) || !dateTimeFunc.validYear(year)) {
        return res.status(400).json({ msg: "Invalid month" });
      }

      // initializing 1st day that month and 1st day the next month
      const from = new Date(year, month - 1, 1);
      let to = new Date(year, month, 1);

      // if the month reporting is Dec, the upper bound must be 1st Jan of the next year
      if (parseInt(month) === 12) {
        to = new Date(parseInt(year) + 1, 0, 1);
      }

      const orderInMonth = await Orders.find({
        purchaseDate: {
          $gte: from,
          $lt: to,
        },
      });

      let result = [];

      // initializing an array with {days in month} elements represent for days in month
      for (let i = 0; i < dateTimeFunc.daysOfMonth(month, year); i++) {
        result.push({ revenue: 0, order: 0 });
      }

      orderInMonth.forEach((order) => {
        if (order.paidStatus === 2) {
          result[order.purchaseDate.getDate() - 1].revenue += order.totalPrice;
          result[order.purchaseDate.getDate() - 1].order++;
        }
      });

      res.status(201).json({
        msg: "Get monthly revenue report successfully",
        data: result,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAnnualBookIssueReport: async (req, res) => {
    try {
      const year = req.query.y;

      if (!dateTimeFunc.validYear(year)) {
        return res.status(400).json({ msg: "Invalid year" });
      }

      // initializing 1st Jan that year and 1st Jan the next year
      const from = new Date(year, 0, 1);
      const to = new Date(parseInt(year) + 1, 0, 1);

      const orderInYear = await Orders.find({
        purchaseDate: {
          $gte: from,
          $lt: to,
        },
      });

      let tempResult = [];

      orderInYear.forEach((order) => {
        if (order.paidStatus === 2) {
          order.details.forEach((detail) => {
            const matchedIndex = tempResult.findIndex((d) => {
              return d.bookId === detail.bookId;
            });

            if (matchedIndex === -1) {
              tempResult.push(detail);
            } else {
              tempResult[matchedIndex].quantity += detail.quantity;
            }
          });
        }
      });

      let result = [];

      for (const temp of tempResult) {
        const { name, author, imageUrl, isAvailable, price, discountRatio } =
          await getBookInfo(temp.bookId);

        result.push({
          ...temp,
          name,
          author,
          imageUrl,
          isAvailable,
          price,
          discountRatio,
        });
      }

      result.sort((a, b) => {
        return b.quantity - a.quantity;
      });

      res.status(201).json({
        msg: "Get annual book issue report successfully",
        data: result,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getMonthlyBookIssueReport: async (req, res) => {
    try {
      const month = req.query.m;
      const year = req.query.y;

      if (!dateTimeFunc.validMonth(month) || !dateTimeFunc.validYear(year)) {
        return res.status(400).json({ msg: "Invalid month" });
      }

      // initializing 1st day that month and 1st day the next month
      const from = new Date(year, month - 1, 1);
      let to = new Date(year, month, 1);

      // if the month reporting is Dec, the upper bound must be 1st Jan of the next year
      if (parseInt(month) === 12) {
        to = new Date(parseInt(year) + 1, 0, 1);
      }

      const orderInMonth = await Orders.find({
        purchaseDate: {
          $gte: from,
          $lt: to,
        },
      });

      let tempResult = [];

      orderInMonth.forEach((order) => {
        if (order.paidStatus === 2) {
          order.details.forEach((detail) => {
            const matchedIndex = tempResult.findIndex((d) => {
              return d.bookId === detail.bookId;
            });

            if (matchedIndex === -1) {
              tempResult.push(detail);
            } else {
              tempResult[matchedIndex].quantity += detail.quantity;
            }
          });
        }
      });

      let result = [];

      for (const temp of tempResult) {
        const { name, author, imageUrl, isAvailable, price, discountRatio } =
          await getBookInfo(temp.bookId);

        result.push({
          ...temp,
          name,
          author,
          imageUrl,
          isAvailable,
          price,
          discountRatio,
        });
      }

      result.sort((a, b) => {
        return b.quantity - a.quantity;
      });

      res.status(201).json({
        msg: "Get monthly book issue report successfully",
        data: result,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

async function deliveredBook(bookId, deliveredQuantity) {
  const book = await Books.findById(bookId);

  if (!book || book.quantity < deliveredQuantity) {
    return false;
  }

  book.quantity -= deliveredQuantity;
  return true;
}

async function getBookInfo(bookId) {
  const { name, author, imageUrl, isAvailable, price, discountRatio } =
    await Books.findById(bookId);

  return { name, author, imageUrl, isAvailable, price, discountRatio };
}

module.exports = orderController;
