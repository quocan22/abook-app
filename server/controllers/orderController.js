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
  getAllOrdersGeneralInfo: async (req, res) => {
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

      const { userClaim } = await Users.findById(order.userId);

      // order is a MongoDB document, so it must be converted to an object
      var orderRes = order.toObject();
      orderRes.details = booksRes;
      orderRes.customerName = userClaim.displayName;
      orderRes.customerPhone = userClaim.phoneNumber;
      orderRes.customerAddress = userClaim.address;

      res.status(200).json({
        msg: "Get order information successfully",
        data: orderRes,
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

      if (!validYear(year)) {
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

      var result = new Array();

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

      if (!validMonth(month) || !validYear(year)) {
        return res.status(400).json({ msg: "Invalid month" });
      }

      // initializing 1st day that month and 1st day the next month
      const from = new Date(year, month - 1, 1);
      var to = new Date(year, month, 1);

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

      var result = new Array();

      // initializing an array with {days in month} elements represent for days in month
      for (let i = 0; i < daysOfMonth(month, year); i++) {
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
  getAnnualBookReport: async (req, res) => {
    try {
      const year = req.query.y;

      if (!validYear(year)) {
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

      var tempResult = new Array();

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

      var result = new Array();

      for (const temp of tempResult) {
        const { name, author, imageUrl, isAvailable, price } =
          await getBookInfo(temp.bookId);

        result.push({ ...temp, name, author, imageUrl, isAvailable, price });
      }

      result.sort((a, b) => {
        return b.quantity - a.quantity;
      });

      res.status(201).json({
        msg: "Get annual book report successfully",
        data: result,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getMonthlyBookReport: async (req, res) => {
    try {
      const month = req.query.m;
      const year = req.query.y;

      if (!validMonth(month) || !validYear(year)) {
        return res.status(400).json({ msg: "Invalid month" });
      }

      // initializing 1st day that month and 1st day the next month
      const from = new Date(year, month - 1, 1);
      var to = new Date(year, month, 1);

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

      var tempResult = new Array();

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

      var result = new Array();

      for (const temp of tempResult) {
        const { name, author, imageUrl, isAvailable, price } =
          await getBookInfo(temp.bookId);

        result.push({ ...temp, name, author, imageUrl, isAvailable, price });
      }

      result.sort((a, b) => {
        return b.quantity - a.quantity;
      });

      res.status(201).json({
        msg: "Get monthly book report successfully",
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

function validYear(year) {
  // regex for checking if year is valid
  const regex = /\b(19|20)\d\d\b/g;

  return regex.test(year);
}

function validMonth(month) {
  // regex for checking if month is valid
  const regex = /^([1-9]|[1][0-2]?)$/g;

  return regex.test(month);
}

function daysOfMonth(month, year) {
  // month in javascript starts at 0 (Jan is 0, Feb is 1), but by using 0 as the day
  // it will give us the last day of previous month, so passing 0 as day and month as
  // month will return the last day of that month
  return new Date(year, month, 0).getDate();
}

async function getBookInfo(bookId) {
  const { name, author, imageUrl, isAvailable, price } = await Books.findById(
    bookId
  );

  return { name, author, imageUrl, isAvailable, price };
}

module.exports = orderController;
