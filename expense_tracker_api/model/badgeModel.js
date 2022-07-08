const mongoose = require("mongoose");

const badgeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
    },

    requiredProgressPoint: {
      type: Number,
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

const badge = mongoose.model("badge", badgeSchema);

module.exports = badge;
