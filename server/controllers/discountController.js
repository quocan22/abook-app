const Discounts = require("../models/discountModel");

const discountController = {
  getAllDiscounts: async (req, res) => {
    try {
      const discounts = await Discounts.find();

      res.json({
        msg: "Get all discounts successfully",
        result: discounts.length,
        data: discounts,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getAvailableDiscounts: async (req, res) => {
    try {
      const discounts = await Discounts.find({
        expiredDate: { $gt: Date.now() },
      });

      res.json({
        msg: "Get all available discounts successfully",
        result: discounts.length,
        data: discounts,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  createDiscount: async (req, res) => {
    try {
      const { code, value, expiredDate } = req.body;

      const parseExpiredDate = new Date(expiredDate);

      if (parseExpiredDate < Date.now()) {
        return res
          .status(400)
          .json({ msg: "Expired date is earlier than today" });
      }

      const existedCode = await Discounts.find({ code: code }).count();

      if (existedCode > 0) {
        return res.status(400).json({ msg: "This code has been used" });
      }

      const newDiscount = new Discounts({
        code,
        value,
        expiredDate: parseExpiredDate,
      });

      await newDiscount.save();

      res.status(200).json({ msg: "Create discount successfully" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateDiscount: async (req, res) => {
    try {
      const { id, code, value, expiredDate } = req.body;

      const discount = await Discounts.findById(id);

      if (!discount) {
        return res.status(404).json({ msg: "Cannot find this discount" });
      }

      if (code !== discount.code) {
        const existedCode = await Discounts.find({ code: code }).count();

        if (existedCode > 0) {
          return res.status(400).json({ msg: "This code has been used" });
        }
      }

      if (expiredDate) {
        const parseExpiredDate = new Date(expiredDate);

        if (parseExpiredDate < Date.now()) {
          return res
            .status(400)
            .json({ msg: "Expired date is earlier than today" });
        }

        discount.expiredDate = parseExpiredDate;
      }

      if (code) discount.code = code;
      if (value) discount.value = value;

      await discount.save();
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  deleteDiscount: async (req, res) => {
    try {
      await Discounts.findByIdAndDelete(req.params.id);

      res.status(202).json({ msg: "Delete discount successfully" });
    } catch {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = discountController;
