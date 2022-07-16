const mongoose = require("mongoose");

const incomeSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },

    name: {
      type: String,
      trim: true,
    },

    amount: {
      type: Number,
    },

    category: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

const income = mongoose.model("income", incomeSchema);

module.exports = income;
