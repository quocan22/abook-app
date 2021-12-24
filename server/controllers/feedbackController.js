const Feedbacks = require("../models/feedbackModel");

const feedbackController = {
  getAllFeedbacks: async (req, res) => {
    try {
      const feedbacks = await Feedbacks.find();

      res.json({
        msg: "Get all feedbacks successfully",
        result: feedbacks.length,
        data: feedbacks,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createFeedback: async (req, res) => {
    try {
      const { email, content } = req.body;

      const feedback = new Feedbacks({
        email,
        content,
      });

      await feedback.save();

      res.status(202).json({ msg: "Create feedback successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = feedbackController;
