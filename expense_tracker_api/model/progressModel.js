const mongoose = require("mongoose");

const progressSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },

    Progress: {
      type: Number,
      default: 10,
    },

    PMP: {
      type: Number,
      default: 0,
    },

    badge: {
      type: mongoose.Schema.ObjectId,
      ref: "badge",
    },

    achievement: [
      {
        type: mongoose.Schema.ObjectId,
        ref: "badge",
      },
    ],
  },
  {
    timestamps: true,
  }
);

const progress = mongoose.model("progress", progressSchema);

module.exports = progress;