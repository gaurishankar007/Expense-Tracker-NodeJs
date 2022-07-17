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

    pmc: {
      type: Date,
    },
  },
  {
    timestamps: true,
  }
);

const progress = mongoose.model("progress", progressSchema);

module.exports = progress;
