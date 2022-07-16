const asyncHandler = require("express-async-handler");
const achievement = require("../model/achievementModel");
const user = require("../model/userModel");

const createAchievement = asyncHandler(async (req, res) => {
  const { name, description, progressPoint } = req.body;

  const progressPointRegex = new RegExp("^[0-9]+$");

  if (
    name.trim() === "" ||
    name === undefined ||
    description.trim() === "" ||
    description === undefined ||
    progressPoint === undefined
  ) {
    return res.status(400).send({ resM: "Provide both name and description" });
  } else if (!progressPointRegex.test(progressPoint)) {
    return res.status(400).send({ resM: "Invalid progressPoint." });
  }

  const newAchievement = new achievement({
    name: name,
    description: description,
    progressPoint: progressPoint,
  });

  newAchievement.save().then(() => {
    res.status(201).send({ resM: name + " achievement created." });
  });
});

const removeAchievement = (req, res) => {
  achievement.findByIdAndDelete(req.body.achievementId).then(() => {
    res.send({ resM: "Achievement removed." });
  });
};

const getAllAchievement = asyncHandler(async (req, res) => {
  const achievements = await achievement.find();
  res.send(achievements);
});

module.exports = { createAchievement, removeAchievement, getAllAchievement };
