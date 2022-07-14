const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const progress = require("../model/progressModel");
const user = require("../model/userModel");

router.get("/user/getProgress", auth.verifyUser, async (req, res) => {
  const userProgress = await progress
    .findOne({ user: req.userInfo._id })
    .populate("user", "email profileName profilePicture gender profilePublication")
    .populate("oldAchievement", "name description")
    .populate("newAchievement", "name description");

  res.send({ progress: userProgress });
});

router.get("/users/progresses", auth.verifyUser, async (req, res) => {
  const users  = await user.find({progressPublication: true});

  const progressPoints = await progress
    .find({user: {$in: users}})
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ progress: -1 })
    .limit(20);

  const tmpPoints = await progress
    .find({user: {$in: users}})
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ tmp: -1 })
    .limit(20);

  const pmpPoints = await progress
    .find({user: {$in: users}})
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ pmp: -1 })
    .limit(20);

  res.send({
    progressPoints: progressPoints,
    tmpPoints: tmpPoints,
    pmpPoints: pmpPoints,
  });
});

module.exports = router;
