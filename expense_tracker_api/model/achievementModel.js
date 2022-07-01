const mongoose = require("mongoose");

const achievementSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
    },

    description: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

const achievement = mongoose.model("achievement", achievementSchema);

module.exports = achievement;
