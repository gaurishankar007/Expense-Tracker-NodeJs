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
      default: "https://res.cloudinary.com/gaurishankar/image/upload/v1657982085/xstpveuuak5kzekmmm9y.png"
    },

    gender: {
      type: String,
      default: ""
    },
    
    progressPublication: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

const user = mongoose.model("user", userSchema);

module.exports = user;
