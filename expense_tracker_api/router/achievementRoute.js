const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const {
  createAchievement,
  removeAchievement,
  getAllAchievement,
} = require("../controller/achievementController");

router.post("/create", verifyUser, createAchievement);

router.delete("/remove", verifyUser, removeAchievement);

router.get("/getAll", verifyUser, getAllAchievement);

module.exports = router;
