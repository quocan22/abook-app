const dialogflow = require("@google-cloud/dialogflow");
const uuid = require("uuid");

const dialogflowCredentials = require("../utils/keys");
const Orders = require("../models/orderModel");
const Books = require("../models/bookModel");
const Categories = require("../models/categoryModel");

const projectId = dialogflowCredentials.projectId;
const languageCode = dialogflowCredentials.sessionLanguageCode;
const sessionId = uuid.v4();

const sessionClient = new dialogflow.SessionsClient();
const sessionPath = sessionClient.projectAgentSessionPath(projectId, sessionId);

//#region Action definement
const BEST_SELLING_ACTION = "bestSell";
const NEW_ARRIVALS_ACTION = "newArrivals";
const CATEGORY_SEARCH_ACTION = "categorySearch";
const SEARCH_BOOK_BY_CATEGORY = "searchBookByCate";
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
      case SEARCH_BOOK_BY_CATEGORY:
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

    const result = responses[0].queryResult;

    res.status(200).json(result);
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
  const from = new Date(new Date().getFullYear(), new Date().getMonth());
  const to = new Date(new Date().getFullYear(), new Date().getMonth() + 1);

  const ordersInMonth = await Orders.find({
    purchaseDate: {
      $gte: from,
      $lt: to,
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
