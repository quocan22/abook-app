const dialogflow = require("@google-cloud/dialogflow");
const uuid = require("uuid");

const dialogflowCredentials = require("../utils/keys");
const Orders = require("../models/orderModel");
const Books = require("../models/bookModel");

const projectId = dialogflowCredentials.projectId;
const languageCode = dialogflowCredentials.sessionLanguageCode;
const sessionId = uuid.v4();

const sessionClient = new dialogflow.SessionsClient();
const sessionPath = sessionClient.projectAgentSessionPath(projectId, sessionId);

//#region Action definement
const BEST_SELLING_ACTION = "bestSell";
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
        bestSellInMonth(req, res);
        break;
      case "makeOrder":
        makeOrder(req, res, responses);
        break;
      default:
        const result = responses[0].queryResult;
        res.status(200).json(result);
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

async function bestSellInMonth(req, res) {
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

    const { name, author, imageUrl, isAvailable, price } = await Books.findById(
      bestSellId
    );

    res.status(200).json({
      msg: "This book has the most selling this month",
      data: { name, author, imageUrl, isAvailable, price },
    });
  }
}

async function makeOrder(req, res, responses) {
  const result = responses[0].queryResult;
  if (!result.allRequiredParamsPresent) {
    const message = result.fulfillmentMessages[0].text.text[0];
    res.status(200).json({ msg: message });
  } else {
    res.status(200).json({ msg: "Your order is ready." });
  }
}

module.exports = chatbotController;
