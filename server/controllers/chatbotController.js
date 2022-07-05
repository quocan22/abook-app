const dialogflow = require("@google-cloud/dialogflow");
const uuid = require("uuid");

const Orders = require("../models/orderModel");
const Books = require("../models/bookModel");
const Categories = require("../models/categoryModel");

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
//#endregion

const chatbotController = {
  textQuery: async (req, res) => {
    const request = {
      session: sessionPath,
      queryInput: {
        text: {
          // The query to send to the dialogflow agent
          text: req.body.text,
          // The language used by the client (en-US)
          languageCode: languageCode,
        },
      },
    };

    const responses = await sessionClient.detectIntent(request);

    const action = responses[0].queryResult.action;

    switch (action) {
      case BEST_SELLING_ACTION:
        bestSellInMonth(res);
        break;
      case NEW_ARRIVALS_ACTION:
        newArrivals(res);
        break;
      case CATEGORY_SEARCH_ACTION:
        categorySearch(res);
        break;
      case SEARCH_BOOK_BY_CATEGORY_ACTION:
        searchBookByCate(res, responses);
        break;
      case BEST_DISCOUNT_ACTION:
        bestDiscount(res, responses);
        break;
      case MOST_EXPENSIVE_ACTION:
        mostExpensive(res);
        break;
      case CHEAPEST_ACTION:
        cheapest(res);
        break;
      case GIVE_CATE_TO_FIND_BOOK:
        searchBookByCate(res, responses);
        break;
      case "makeOrder":
        makeOrder(res, responses);
        break;
      default:
        defaultAction(res, responses);
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
          languageCode: languageCode,
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

function defaultAction(res, responses) {
  const text = responses[0].queryResult.fulfillmentMessages[0].text.text[0];

  res.status(200).json({
    type: 1,
    text: text,
  });
}

async function bestSellInMonth(res) {
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
    res.status(200).json({ msg: "Not enough data to show most selling book" });
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

    res.status(200).json({
      type: 2,
      text: "This book has the most selling this month",
      data: [book],
    });
  }
}

async function newArrivals(res) {
  const books = await Books.find().sort({ createdAt: 1 });

  if (books.length < 1) {
    res.status(200).json({
      type: 1,
      text: "Sorry, we have not enough data to show you.",
    });
  } else {
    res.status(200).json({
      type: 2,
      text: "We have 3 new arrivals for you.",
      data: books.slice(0, 3),
    });
  }
}

async function categorySearch(res) {
  const categories = await Categories.find();

  if (!categories) {
    res.status(200).json({
      type: 1,
      text: "Sorry, we have not enough data to show you.",
    });
  } else {
    res.status(200).json({
      type: 3,
      text: "We have some kinds of book for you.",
      data: categories,
    });
  }
}

async function searchBookByCate(res, responses) {
  const categoryName =
    responses[0].queryResult.parameters.fields.categoryName.stringValue;

  const category = await Categories.findOne({ categoryName: categoryName });

  if (!category) {
    res.status(200).json({
      type: 1,
      text: "Sorry, we don't have that kind of book in our store.",
    });
  } else {
    const books = await Books.find({ categoryId: category._id });

    res.status(200).json({
      type: 2,
      text: "We recommend some books for you.",
      data: books,
    });
  }
}

async function bestDiscount(res) {
  const bestDiscountBooks = await Books.find()
    .sort({ discountRatio: -1, createdAt: 1 })
    .limit(5);

  if (bestDiscountBooks.length < 1) {
    res.status(200).json({
      type: 1,
      text: "Sorry, we don't have enough data to show you.",
    });
  } else {
    res.status(200).json({
      type: 2,
      text: "These are best discount books on ABook Store.",
      data: bestDiscountBooks,
    });
  }
}

async function mostExpensive(res) {
  const mostExpensiveBook = await Books.find().sort({ price: -1 }).limit(1);

  if (mostExpensiveBook.length > 0) {
    const price = formatCurrency(mostExpensiveBook[0].price);

    res.status(200).json({
      type: 2,
      text: `This is the most expensive book in our store with the price is ${price}.`,
      data: mostExpensiveBook,
    });
  } else {
    res.status(200).json({
      type: 1,
      text: "Sorry, we have a temporary issue so we cannot show you the most expensive book right now.",
    });
  }
}

async function cheapest(res) {
  const cheapestBook = await Books.find().sort({ price: 1 }).limit(1);

  if (cheapestBook.length > 0) {
    const price = formatCurrency(cheapestBook[0].price);

    res.status(200).json({
      type: 2,
      text: `This is the cheapest book in our store with the price is ${price}.`,
      data: cheapestBook,
    });
  } else {
    res.status(200).json({
      type: 1,
      text: "Sorry, we have a temporary issue so we cannot show you the cheapest book right now.",
    });
  }
}

async function makeOrder(res, responses) {
  const result = responses[0].queryResult;
  if (!result.allRequiredParamsPresent) {
    const message = result.fulfillmentMessages[0].text.text[0];
    res.status(200).json({ msg: message });
  } else {
    res.status(200).json({ msg: "Your order is ready." });
  }
}

module.exports = chatbotController;
