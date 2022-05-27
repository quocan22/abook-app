const BookReceipts = require("../models/bookReceiptModel");
const Books = require("../models/bookModel");
const dateTimeFunc = require("../utils/dateTimeFunc");

const bookReceiptController = {
  getBookReceiptDetails: async (req, res) => {
    try {
      const bookReceipt = await BookReceipts.findById(req.params.id);

      // check if book receipt exists
      if (!bookReceipt) {
        return res.status(404).json({ msg: "Cannot find this book receipt" });
      }

      let receiptDetails = bookReceipt.details;

      for (let i = 0; i < bookReceipt.details.length; i++) {
        const book = await Books.findById(bookReceipt.details[i].bookId);

        const { name, imageUrl, isAvailable } = book.toObject();

        receiptDetails[i].name = name;
        receiptDetails[i].imageUrl = imageUrl;
        receiptDetails[i].isAvailable = isAvailable;
        receiptDetails[i].total =
          receiptDetails[i].price * receiptDetails[i].quantity;
      }

      res.json({
        msg: "Get book receipt successfully",
        data: receiptDetails,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  receiveBooks: async (req, res) => {
    try {
      const { books } = req.body;

      if (!books) {
        return res.status(400).json({ msg: "There is nothing to receipt" });
      }

      const bookReceipt = new BookReceipts();

      for (const b of books) {
        const result = await updateBook(b.bookId, b.quantity, b.price);

        if (result === false) {
          return res.status(400).json({ msg: "Something went wrong" });
        }

        bookReceipt.details.push({
          bookId: b.bookId,
          quantity: Number(b.quantity),
          price: Number(b.price),
        });
        bookReceipt.totalPrice += b.price * b.quantity;
      }

      await bookReceipt.save();

      res.status(202).json({ msg: "Receipting book successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAnnualBookReceiptReport: async (req, res) => {
    try {
      const year = req.query.y;

      if (!dateTimeFunc.validYear(year)) {
        return res.status(400).json({ msg: "Invalid year" });
      }

      // initializing 1st Jan that year and 1st Jan the next year
      const from = new Date(year, 0, 1);
      const to = new Date(parseInt(year) + 1, 0, 1);

      const receiptInYear = await BookReceipts.find({
        receiptDate: {
          $gte: from,
          $lt: to,
        },
      }).select("-details");

      res.status(201).json({
        msg: "Get annual book receipt report successfully",
        data: receiptInYear,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getMonthlyBookReceiptReport: async (req, res) => {
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

      const receiptInMonth = await BookReceipts.find({
        receiptDate: {
          $gte: from,
          $lt: to,
        },
      }).select("-details");

      res.status(201).json({
        msg: "Get monthly book receipt report successfully",
        data: receiptInMonth,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

async function updateBook(bookId, quantity, price) {
  const book = await Books.findById(bookId);

  if (!book) {
    return false;
  }

  book.quantity = Number(book.quantity) + Number(quantity);
  book.price = price;

  await book.save();

  return true;
}

module.exports = bookReceiptController;
