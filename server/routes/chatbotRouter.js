const router = require("express").Router();

const chatbotController = require("../controllers/chatbotController");

router.post("/text_query", chatbotController.textQuery);
router.post("/event_query", chatbotController.eventQuery);

module.exports = router;
