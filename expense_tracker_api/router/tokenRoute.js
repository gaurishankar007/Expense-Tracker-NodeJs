const express = require("express");
const router = new express.Router();
const { generateToken, verifyToken } = require("../controller/tokenController");

router.post("/generate", generateToken);

router.put("/verify", verifyToken);

module.exports = router;
