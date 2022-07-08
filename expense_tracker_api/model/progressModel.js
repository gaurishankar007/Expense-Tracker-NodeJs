const mongoose = require("mongoose");

const progressSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },

    progress: {
      type: Number,
      default: 10,
    },

    tmp: {
      type: Number,
      default: 0,
    },

    pmp: {
      type: Number,
      default: 0,
    },

    badge: {
      type: mongoose.Schema.ObjectId,
      ref: "badge",
    },

    pMBadge: {
      type: mongoose.Schema.ObjectId,
      ref: "badge",
    },

    oldAchievement: [
      {
        type: mongoose.Schema.ObjectId,
        ref: "achievement",
      },
    ],

    newAchievement: [
      {
        type: mongoose.Schema.ObjectId,
        ref: "achievement",
      },
    ],
  },
  {
    timestamps: true,
  }
);

const progress = mongoose.model("progress", progressSchema);

module.exports = progress;
