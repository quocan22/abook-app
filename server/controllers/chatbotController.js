const dialogflow = require("@google-cloud/dialogflow");
const uuid = require("uuid");

const Orders = require("../models/orderModel");
const Books = require("../models/bookModel");
const Categories = require("../models/categoryModel");
const Users = require("../models/userModel");

const dialogflowCredentials = require("../utils/keys");
const formatCurrency = require("../utils/formatCurrency");

const projectId = dialogflowCredentials.projectId;
const languageCode = dialogflowCredentials.sessionLanguageCode;
const sessionId = uuid.v4();

const googleCredentials = JSON.parse(process.env.GOOGLE_CREDENTIALS.toString());
const sessionClient = new dialogflow.SessionsClient({
  credentials: googleCredentials,
});
const sessionPath = sessionClient.projectAgentSessionPath(projectId, sessionId);

//#region Action definement
const BEST_SELLING_ACTION = "bestSell";
const NEW_ARRIVALS_ACTION = "newArrivals";
const CATEGORY_SEARCH_ACTION = "categorySearch";
const SEARCH_BOOK_BY_CATEGORY_ACTION = "searchBookByCate";
const BEST_DISCOUNT_ACTION = "bestDiscount";
const MOST_EXPENSIVE_ACTION = "mostExpensive";
const CHEAPEST_ACTION = "cheapest";
const GIVE_CATE_TO_FIND_BOOK = "giveCateToFindBook";
const BUY_A_BOOK_ACTION = "buyABook";
const MAKE_ORDER_ACTION = "makeOrder";
const CONFIRM_ORDER_ACTION = "confirmOrder";
//#endregion

const chatbotController = {
  textQuery: async (req, res) => {
    const request = {
      session: sessionPath,
      queryInput: {
        text: {
          // The query to send to the dialogflow agent
          text: req.body.text,
          // The language used by the client (vi-VN)
          languageCode: req.body.languageCode,
        },
      },
    };

    const responses = await sessionClient.detectIntent(request);

    const action = responses[0].queryResult.action;

    switch (action) {
      case BEST_SELLING_ACTION:
        bestSellInMonth(req, res, responses);
        break;
      case NEW_ARRIVALS_ACTION:
        newArrivals(req, res, responses);
        break;
      case CATEGORY_SEARCH_ACTION:
        categorySearch(req, res, responses);
        break;
      case SEARCH_BOOK_BY_CATEGORY_ACTION:
        searchBookByCate(req, res, responses);
        break;
      case BEST_DISCOUNT_ACTION:
        bestDiscount(req, res, responses);
        break;
      case MOST_EXPENSIVE_ACTION:
        mostExpensive(req, res, responses);
        break;
      case CHEAPEST_ACTION:
        cheapest(req, res, responses);
        break;
      case GIVE_CATE_TO_FIND_BOOK:
        searchBookByCate(req, res, responses);
        break;
      case BUY_A_BOOK_ACTION:
        buyABook(req, res, responses);
        break;
      case MAKE_ORDER_ACTION:
        makeOrder(req, res, responses);
        break;
      case CONFIRM_ORDER_ACTION:
        confirmOrder(req, res, responses);
        break;
      default:
        defaultAction(req, res, responses);
        break;
    }

    // const result = responses[0].queryResult;

    // res.status(200).json(result);
  },
  eventQuery: async (req, res) => {
    const request = {
      session: sessionPath,
      queryInput: {
        event: {
          // The query to send to the dialogflow agent
          name: req.body.event,
          // The language used by the client (en-US)
          languageCode: req.body.languageCode,
        },
      },
    };

    const responses = await sessionClient.detectIntent(request);

    const text = responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 1,
      text: text,
    });
  },
};

function defaultAction(req, res, responses) {
  const message = responses[0].queryResult.fulfillmentMessages[0].text.text[0];

  res.status(200).json({
    type: 1,
    text: message,
  });
}

async function bestSellInMonth(req, res, responses) {
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
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Không đủ dữ liệu để hiển thị sách bán chạy."
          : "Not enough data to show you best selling book.",
    });
  } else {
    let bestSellId = "";
    let maxQuantity = 0;

    booksInMonth.forEach((book) => {
      if (book.quantity > maxQuantity) {
        maxQuantity = book.quantity;
        bestSellId = book.bookId;
      }
    });

    const book = await Books.findById(bestSellId);

    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: [book],
    });
  }
}

async function newArrivals(req, res, responses) {
  const books = await Books.find().sort({ createdAt: -1 });

  if (books.length < 1) {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, chúng tôi không có đủ dữ liệu để hiển thị cho bạn."
          : "Sorry, we do not have enough data to show you.",
    });
  } else {
    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: books.slice(0, 3),
    });
  }
}

async function categorySearch(req, res, responses) {
  const categories = await Categories.find();

  if (!categories) {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, chúng tôi không có đủ dữ liệu để hiển thị cho bạn."
          : "Sorry, we do not have enough data to show you.",
    });
  } else {
    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 3,
      text: message,
      data: categories,
    });
  }
}

async function searchBookByCate(req, res, responses) {
  const categoryName =
    responses[0].queryResult.parameters.fields.categoryName.stringValue;

  const category = await Categories.findOne({ categoryName: categoryName });

  if (!category) {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, ABook hiện chưa có thể loại sách mà bạn cần."
          : "Sorry, we do not have the kind of book you want.",
    });
  } else {
    const books = await Books.find({ categoryId: category._id });

    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: books,
    });
  }
}

async function bestDiscount(req, res, responses) {
  const bestDiscountBooks = await Books.find()
    .sort({ discountRatio: -1, createdAt: 1 })
    .limit(5);

  if (bestDiscountBooks.length < 1) {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, chúng tôi không có đủ dữ liệu để hiển thị cho bạn."
          : "Sorry, we do not have enough data to show you.",
    });
  } else {
    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: bestDiscountBooks,
    });
  }
}

async function mostExpensive(req, res, responses) {
  const mostExpensiveBook = await Books.find().sort({ price: -1 }).limit(1);

  if (mostExpensiveBook.length > 0) {
    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: mostExpensiveBook,
    });
  } else {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, chúng tôi đang gặp một vài vấn đề nên không thể đáp ứng yêu cầu của bạn ngay được, chúng tôi sẽ quay lại ngay khi có thể."
          : "Sorry, we encounter sudden problem and cannot response your request right now, we will be back as soon as possible.",
    });
  }
}

async function cheapest(req, res, responses) {
  const cheapestBook = await Books.find().sort({ price: 1 }).limit(1);

  if (cheapestBook.length > 0) {
    const message =
      responses[0].queryResult.fulfillmentMessages[0].text.text[0];

    res.status(200).json({
      type: 2,
      text: message,
      data: cheapestBook,
    });
  } else {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Xin lỗi, chúng tôi đang gặp một vài vấn đề nên không thể đáp ứng yêu cầu của bạn ngay được, chúng tôi sẽ quay lại ngay khi có thể."
          : "Sorry, we encounter sudden problem and cannot response your request right now, we will be back as soon as possible.",
    });
  }
}

async function buyABook(req, res, responses) {
  const result = responses[0].queryResult;
  const message = result.fulfillmentMessages[0].text.text[0];

  if (result.allRequiredParamsPresent) {
    res.status(200).json({ type: 1, text: message });
  } else {
    if (
      !result.parameters.fields.bookName ||
      !result.parameters.fields.bookName.stringValue
    ) {
      return res.status(200).json({
        type: 1,
        text:
          req.body.languageCode === "vi-VN"
            ? "Chúng tôi gặp sự cố bất ngờ trong khi tìm kiếm sách theo yêu cầu của bạn."
            : "We have some problems while trying to find book for you.",
      });
    }

    const bookName = result.parameters.fields.bookName.stringValue;

    const book = await Books.findOne({ name: bookName });

    if (!book) {
      return res.status(200).json({
        type: 1,
        text:
          req.body.languageCode === "vi-VN"
            ? "Chúng tôi gặp sự cố bất ngờ trong khi tìm kiếm sách theo yêu cầu của bạn."
            : "We have some problems while trying to find book for you.",
      });
    }

    if (!book.isAvailable) {
      return res.status(200).json({
        type: 2,
        text:
          req.body.languageCode === "vi-VN"
            ? "Chúng tôi tìm thấy quyển sách này dựa trên yêu cầu của bạn, nhưng quyển sách này đã ngừng kinh doanh."
            : "We find this book for you, but it has already stopped business.",
        data: [book],
      });
    }

    return res.status(200).json({
      type: 2,
      text: message,
      data: [book],
    });
  }
}

async function makeOrder(req, res, responses) {
  const result = responses[0].queryResult;
  const message = result.fulfillmentMessages[0].text.text[0];
  res.status(200).json({ type: 1, text: message });
}

async function confirmOrder(req, res, responses) {
  const { bookName, quantity, email, name, phoneNumber, address } =
    responses[0].queryResult.parameters.fields;

  const user = await Users.findOne({ email: email.stringValue });

  let userId = "";

  if (user) {
    userId = user._id;
  }

  const book = await Books.findOne({ name: bookName.stringValue });

  if (!book) {
    res.status(200).json({
      type: 1,
      text:
        req.body.languageCode === "vi-VN"
          ? "Chúng tôi gặp một sự cố bất ngờ. ABook xin lỗi vì sự bất tiện này."
          : "We have some sudden problems. ABook apologize for this inconvenient.",
    });
  }

  const sellPrice = book.price - (book.price * book.discountRatio) / 100;
  const totalPrice = sellPrice * quantity.numberValue;

  const newOrder = new Orders({
    userId: userId,
    totalPrice,
    customerName: name.stringValue,
    customerPhoneNumber: phoneNumber.stringValue,
    customerAddress: address.stringValue,
    details: [
      {
        bookId: book._id.valueOf(),
        quantity: quantity.numberValue,
        sellPrice,
      },
    ],
  });

  await newOrder.save();

  const message = responses[0].queryResult.fulfillmentMessages[0].text.text[0];

  res.status(200).json({
    type: 1,
    text: message,
  });
}

module.exports = chatbotController;
