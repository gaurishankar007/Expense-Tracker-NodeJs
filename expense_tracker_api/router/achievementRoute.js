const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const achievement = require("../model/achievementModel");
const user = require("../model/userModel");

router.post("/achievement/create", auth.verifyUser, async (req, res) => {
  const name = req.body.name;
  const description = req.body.description;
  const progressPoint = req.body.progressPoint;
  
  const progressPointRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || name === undefined || description.trim() === ""  || description === undefined || progressPoint === undefined) {
    return res.status(400).send({ resM: "Provide both name and description" });
  } else if (!progressPointRegex.test(progressPoint)) {
    return res.status(400).send({ resM: "Invalid progressPoint." });
  }

  const newAchievement = new achievement({
    name: name,
    description: description,
    progressPoint: progressPoint
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

router.get("/achievement/getAll", auth.verifyUser, async (req, res)=> {
  const achievements  = await achievement.find();
  res.send(achievements);
})

module.exports = router;
