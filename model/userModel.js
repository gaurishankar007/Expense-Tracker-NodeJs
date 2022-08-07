const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      trim: true,
    },

    password: {
      type: String,
      trim: true,
    },

    profileName: {       
      type: String,
      trim: true,
    },

    profilePicture: {
      type: String,
      default: "https://res.cloudinary.com/gaurishankar/image/upload/v1658148482/ExpenseTracker/p3o8edl8jnwvdhk5xjmx.png"
    },

    gender: {
      type: String,
      default: ""
    },
    
    progressPublication: {
      type: Boolean,
      default: false,
    },

    passReset: {
      type: Date,
      default: null
    }
  },
  {
    timestamps: true,
  }
);

const user = mongoose.model("user", userSchema);

module.exports = user;
