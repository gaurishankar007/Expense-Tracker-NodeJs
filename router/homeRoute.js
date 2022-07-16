const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const { userHomeData } = require("../controller/homeController");

router.get("/userData", verifyUser, userHomeData);

module.exports = router;
