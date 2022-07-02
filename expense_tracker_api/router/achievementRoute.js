const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const achievement = require("../model/achievementModel");
const user = require("../model/userModel");

router.post("/achievement/create", auth.verifyUser, async (req, res) => {
  const name = req.body.name;
  const description = req.body.description;

  if (name.trim() === "" || name === undefined || description.trim() === ""  || description === undefined) {
    return res.status(400).send({ resM: "Provide name, description, and permanent." });
  }

  const newAchievement = new achievement({
    name: name,
    description: description
  });

  newAchievement.save().then(() => {
    res.status(201).send({ resM: name + " achievement created." });
  });
});

router.delete("/achievement/remove", auth.verifyUser, (req, res) => {
  achievement.findByIdAndDelete(req.body.achievementId).then(() => {
    res.send({ resM: "Achievement removed." });
  });
});

module.exports = router;
