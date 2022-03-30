const BookReceipts = require("../models/bookReceiptModel");
const Books = require("../models/bookModel");

const bookReceiptController = {
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

        bookReceipt.details.push(b);
        bookReceipt.totalPrice += b.price;
      }

      await bookReceipt.save();

      res.status(202).json({ msg: "Receipting book successfully" });
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
