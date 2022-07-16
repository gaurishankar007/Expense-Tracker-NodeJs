const asyncHandler = require("express-async-handler");
const progress = require("../model/progressModel");
const user = require("../model/userModel");

const userProgress = asyncHandler(async (req, res) => {
  const userProgress = await progress
    .findOne({ user: req.userInfo._id })
    .populate(
      "user",
      "email profileName profilePicture gender profilePublication"
    )
    .populate("oldAchievement", "name description")
    .populate("newAchievement", "name description");

  res.send({ progress: userProgress });
});

const usersProgress = asyncHandler(async (req, res) => {
  const users = await user.find({ progressPublication: true });

  const progressPoints = await progress
    .find({ user: { $in: users } })
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ progress: -1 })
    .limit(20);

  const tmpPoints = await progress
    .find({ user: { $in: users } })
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ tmp: -1 })
    .limit(20);

  const pmpPoints = await progress
    .find({ user: { $in: users } })
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

const userCalculateProgress = asyncHandler(async (req, res) => {});

module.exports = { userProgress, usersProgress, userCalculateProgress };
