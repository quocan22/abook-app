const Books = require("../models/bookModel");

const bookController = {
  getAllBook: async (req, res) => {
    try {
      const books = await Books.find();

      res.json({
        message: "Get all books successfully",
        result: books.length,
        data: books,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  getBookById: async (req, res) => {
    try {
      const book = await Books.findById(req.params.id);

      if (!book) {
        return res.status(404).json({ message: "Cannot find this book" });
      }

      res.json({
        message: "Get 1 book successfully",
        data: book,
      });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  createBook: async (req, res) => {
    try {
      const { categoryId, name, imageUrl, price, quantity, description } =
        req.body;

      const book = await Books.findOne({ name });

      if (book) {
        return res.status(500).json({ message: "This book already existed" });
      }

      const newBook = new Books({
        categoryId,
        name,
        imageUrl,
        price,
        quantity,
        description,
      });

      await newBook.save();

      res.status(201).json({ message: "Creating book successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  addComment: async (req, res) => {
    try {
      const bookId = req.query.bookId;
      const { userId, rate, review } = req.body;

      const newComment = {
        userId: userId,
        rate: rate,
        review: review,
        commentDate: new Date(),
      };

      const book = await Books.findOne({ _id: bookId });
      if (!book) {
        return res.status(500).json({ message: "This book does not exist" });
      }

      book.comments.push(newComment);
      book.avgRate = updateAvgRate(book.comments);

      await book.save();

      res.status(200).json({ message: "Add new comment successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
  deleteBook: async (req, res) => {
    try {
      await Books.findByIdAndDelete(req.params.id);

      res.status(202).json({ message: "Deleted successfully" });
    } catch (err) {
      return res.status(500).json({ message: err.message });
    }
  },
};

const updateAvgRate = (comments) => {
  var total = 0;
  for (var i = 0; i < comments.length; i++) {
    total += comments[i].rate;
  }

  return total / comments.length;
};

module.exports = bookController;
