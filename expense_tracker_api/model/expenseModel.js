const mongoose = require("mongoose");

const expenseSchema = new mongoose.Schema(
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

const expense = mongoose.model("expense", expenseSchema);

module.exports = expense;
