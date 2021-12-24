const router = require("express").Router();

const feedbackController = require("../controllers/feedbackController");

router.get("/", feedbackController.getAllFeedbacks);
router.post("/", feedbackController.createFeedback);

module.exports = router;
