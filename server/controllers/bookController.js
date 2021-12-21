const { cloudinary } = require("../utils/cloudinary");
const Books = require("../models/bookModel");
const Users = require("../models/userModel");

const bookController = {
  getAllBook: async (req, res) => {
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
  getBookById: async (req, res) => {
    try {
      const book = await Books.findById(req.params.id);

      // check if book exists
      if (!book) {
        return res.status(404).json({ msg: "Cannot find this book" });
      }

      res.json({
        msg: "Get 1 book successfully",
        data: book,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createBook: async (req, res) => {
    try {
      const { categoryId, name, price, quantity, description } = req.body;

      const book = await Books.findOne({ name });

      // check if this name of book exists
      if (book) {
        return res.status(400).json({ msg: "This book already existed" });
      }

      // create a new book
      const newBook = new Books({
        categoryId,
        name,
        price,
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
      const { categoryId, name, isAvailable, price, quantity, description } =
        req.body;

      const book = await Books.findById(req.params.id);

      if (!book) {
        return res.status(404).json({ msg: "Cannot find this book" });
      }

      if (req.file) {
        var result;

        if (book.cloudinaryId !== process.env.DEFAULT_PUBLIC_ID) {
          // if old image is not default, delete it
          await cloudinary.uploader.destroy(book.cloudinaryId);
          // upload image to Cloudinary
          result = await cloudinary.uploader.upload(req.file.path, {
            folder: "abook/book",
          });
        } else {
          // if old image is default, wait the result to be uploaded
          result = await cloudinary.uploader.upload(req.file.path, {
            folder: "abook/book",
          });
        }

        // save new image url and cloudinary id for book
        book.imageUrl = result.secure_url;
        book.cloudinaryId = result.public_id;
      }

      if (categoryId) book.categoryId = categoryId;
      if (name) book.name = name;
      if (price) book.price = price;
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
  receiveBook: async (req, res) => {
    try {
      const { bookId, price, quantity } = req.body;

      const book = await Books.findById(bookId);

      if (!book) {
        return res.status(400).json({ msg: "Cannot find this book" });
      }

      book.quantity += quantity;
      if (price && price !== book.price) {
        book.price = price;
      }

      await book.save();

      res.status(200).json({
        msg: "Receive book successfully",
        id: bookId,
        newPrice: book.price,
        newQuantity: book.quantity,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  addComment: async (req, res) => {
    try {
      const { bookId, userId, rate, review } = req.body;

      // get book by id
      const book = await Books.findOne({ _id: bookId });
      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      // create a new comment
      const newComment = {
        userId: userId,
        rate: rate,
        review: review,
        commentDate: new Date(),
      };

      // add comment to array and update average rate of the book
      book.comments.push(newComment);
      book.avgRate = updateAvgRate(book.comments);

      await book.save();

      res.status(200).json({ msg: "Add new comment successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getComments: async (req, res) => {
    try {
      const book = await Books.findById(req.body.bookId);

      // check if book exists
      if (!book) {
        return res.status(400).json({ msg: "This book does not exist" });
      }

      var commentsRes = book.comments;

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
      book.remove();

      res.status(202).json({ msg: "Deleted successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

const updateAvgRate = (comments) => {
  var total = 0;

  // calc avg rate
  for (var i = 0; i < comments.length; i++) {
    total += comments[i].rate;
  }
  return total / comments.length;
};

module.exports = bookController;
