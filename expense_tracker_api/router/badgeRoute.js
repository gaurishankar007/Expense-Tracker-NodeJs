const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const badge = require("../model/badgeModel");
const user = require("../model/userModel");

router.post("/badge/create", auth.verifyUser, async (req, res) => {
  const name = req.body.name;
  const description = req.body.description;

  if (name.trim() === "" || name === undefined || description.trim() === ""  || description === undefined) {
    res.status(400).send({ resM: "Provide both name and description." });
    return;
  }

  const newBadge = new badge({
    name: name,
    description: description,
  });

  newBadge.save().then(() => {
    res.status(201).send({ resM: name + " badge created." });
  });
});

router.delete("/badge/remove", auth.verifyUser, (req, res) => {
  badge.findByIdAndDelete(req.body.badgeId).then(() => {
    res.send({ resM: "Badge removed." });
  });
});

module.exports = router;
