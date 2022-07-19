const { cloudinary } = require("../utils/cloudinary");
const Books = require("../models/bookModel");
const Users = require("../models/userModel");
const Orders = require("../models/orderModel");

const bookController = {
  getAllBooks: async (req, res) => {
    try {
      const books = await Books.find().sort({ createdAt: -1 });

      // return data after get all books
      res.json({
        msg: "Get all books successfully",
        result: books.length,
        data: books,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAllBooksGeneralInfo: async (req, res) => {
    try {
      const books = await Books.find().select("-comments").sort({ name: 1 });

      res.json({
        msg: "Get all books general info successfully",
        result: books.length,
        data: books,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getBookById: async (req, res) => {
    try {
      const book = await Books.findById(req.params.id);

      // check if book exists
      if (!book) {
        return res.status(404).json({ msg: "Cannot find this book" });
      }

      for (let i = 0; i < book.comments.length; i++) {
        const { email, userClaim } = await getUserInfo(book.comments[i].userId);

        book.comments[i].email = email;
        book.comments[i].owner = userClaim.displayName;
      }

      res.json({
        msg: "Get 1 book successfully",
        data: book,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getBooksByCate: async (req, res) => {
    try {
      const cateId = req.query.c;

      const books = await Books.find({ categoryId: cateId });

      res.status(200).json({
        msg: "Get books by category successfully",
        data: books,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createBook: async (req, res) => {
    try {
      const {
        categoryId,
        name,
        author,
        price,
        discountRatio,
        quantity,
        description,
      } = req.body;

      const book = await Books.findOne({ name });

      // check if this name of book exists
      if (book) {
        return res.status(400).json({ msg: "This book already existed" });
      }

      // create a new book
      const newBook = new Books({
        categoryId,
        name,
        author,
        price,
        discountRatio,
        quantity,
        description,
      });

      // if create new book with image
      if (req.file) {
        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/book",
        });

        // set image url and image id for new book
        newBook.imageUrl = result.secure_url;
        newBook.cloudinaryId = result.public_id;
      }

      await newBook.save();

      res.status(201).json({ msg: "Create book successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateInfo: async (req, res) => {
    try {
      const {
        categoryId,
        name,
        author,
        isAvailable,
        price,
        discountRatio,
        quantity,
        description,
      } = req.body;

      const book = await Books.findById(req.params.id);

      if (!book) {
        return res.status(404).json({ msg: "Cannot find this book" });
      }

      if (req.file) {
        if (book.cloudinaryId !== process.env.DEFAULT_BOOK_PUBLIC_ID) {
          // if old image is not default, delete it
          await cloudinary.uploader.destroy(book.cloudinaryId);
        }

        // upload image to Cloudinary
        const result = await cloudinary.uploader.upload(req.file.path, {
          folder: "abook/book",
        });

        // save new image url and cloudinary id for book
        book.imageUrl = result.secure_url;
        book.cloudinaryId = result.public_id;
      }

      if (categoryId) book.categoryId = categoryId;
      if (name) book.name = name;
      if (author) book.author = author;
      if (price) book.price = price;
      if (discountRatio) book.discountRatio = discountRatio;
      if (quantity) book.quantity = quantity;
      if (description) book.description = description;
      book.isAvailable = isAvailable;

      await book.save();

      res.status(200).json({
        msg: "Update book information successfully",
        data: book,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  addComment: async (req, res) => {
    try {
      const { bookId, userId, rate, review } = req.body;

      // get book by id
      const book = await Books.findById(bookId);
      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      // check if user exists
      const user = await Users.findById(userId);
      if (!user) {
        return res.status(400).json({ msg: "Cannot find this user" });
      }

      // create a new comment
      const newComment = {
        userId,
        rate,
        review,
        commentDate: new Date(),
      };

      const matchedCommentIndex = book.comments.findIndex((c) => {
        return c.userId === userId;
      });

      if (matchedCommentIndex === -1) {
        // add comment to array
        book.comments.push(newComment);
      } else {
        book.comments[matchedCommentIndex] = newComment;
      }

      // update average rate of the book
      book.avgRate = updateAvgRate(book.comments);

      await book.save();

      res.status(200).json({ msg: "Review book successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getComments: async (req, res) => {
    try {
      const book = await Books.findById(req.query.i);

      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      let commentsRes = book.comments;

      // Get info of comments owner
      for (let i = 0; i < book.comments.length; i++) {
        let user = await Users.findById(book.comments[i].userId);
        let userInfo = user.userClaim;

        commentsRes[i].owner = userInfo;
      }

      res.status(200).json({
        msg: "Get comments successfully",
        result: commentsRes.length,
        data: commentsRes,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  deleteComment: async (req, res) => {
    try {
      const { bookId, deleteIndex } = req.body;

      const book = await Books.findById(bookId);

      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      book.comments.splice(deleteIndex, 1);

      book.save();

      res.status(200).json({
        msg: "Delete comment successfully",
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  deleteBook: async (req, res) => {
    try {
      const book = await Books.findById(req.params.id);

      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      // if book image is not default, delete it
      if (book.cloudinaryId !== process.env.DEFAULT_BOOK_PUBLIC_ID) {
        await cloudinary.uploader.destroy(book.cloudinaryId);
      }

      // remove book from database
      await book.remove();

      res.status(202).json({ msg: "Delete book successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  bestSellerBooksInMonth: async (req, res) => {
    try {
      // define the time range is 30 days to the past
      const from = new Date();
      from.setMonth(new Date().getMonth() - 1);
      from.setHours(0, 0, 0, 0);
      const to = new Date();
      to.setHours(0, 0, 0, 0);

      const ordersInMonth = await Orders.find({
        purchaseDate: {
          $gte: from,
          $lte: to,
        },
      });

      let booksInMonth = [];

      ordersInMonth.forEach((order) => {
        if (order.paidStatus === 2) {
          order.details.forEach((detail) => {
            const matchedIndex = booksInMonth.findIndex((d) => {
              return d.bookId === detail.bookId;
            });

            if (matchedIndex === -1) {
              booksInMonth.push(detail);
            } else {
              booksInMonth[matchedIndex].quantity += detail.quantity;
            }
          });
        }
      });

      if (booksInMonth.length < 1) {
        res
          .status(200)
          .json({ msg: "Not enough data to show most selling book" });
      } else {
        let bestSellBooks = [];

        booksInMonth.sort((a, b) => {
          return b.quantity - a.quantity;
        });

        for (let i = 0; i < booksInMonth.length; i++) {
          const book = await Books.findById(booksInMonth[i].bookId);

          bestSellBooks.push(book);
        }

        res.status(200).json({
          msg: "3 best selling books this 30 days",
          data: bestSellBooks,
        });
      }
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getBooksName: async (req, res) => {
    try {
      const books = await Books.find();

      const result = [];

      for (let i = 0; i < books.length; i++) {
        result.push(books[i].name);
      }

      res.status(200).json({ result });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

function updateAvgRate(comments) {
  let total = 0;

  // calc avg rate
  for (let i = 0; i < comments.length; i++) {
    total += comments[i].rate;
  }
  return total / comments.length;
}

async function getUserInfo(userId) {
  const { email, userClaim } = await Users.findById(userId);

  return { email, userClaim };
}

module.exports = bookController;
