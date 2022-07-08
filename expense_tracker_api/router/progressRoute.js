const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const progress = require("../model/progressModel");

router.get("/user/getProgress", auth.verifyUser, async (req, res) => {
  const userProgress = await progress
    .findOne({ user: req.userInfo._id })
    .populate("user")
    .populate("badge")
    .populate("pMBadge");

  res.send({ progress: userProgress });
});

module.exports = router;
