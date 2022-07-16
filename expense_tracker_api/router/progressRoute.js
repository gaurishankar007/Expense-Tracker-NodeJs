const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const {
  userProgress,
  usersProgress,
  userCalculateProgress,
} = require("../controller/progressController");

router.get("/user", verifyUser, userProgress);

router.get("/users", verifyUser, usersProgress);

router.get("/userCalculateProgress", verifyUser, userCalculateProgress);

module.exports = router;
