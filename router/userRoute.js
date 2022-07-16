const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const {
  registerUser,
  loginUser,
  viewUser,
  changeProfilePicture,
  changeEmail,
  changeProfileName,
  changePassword,
  changeGender,
  publishProgress,
} = require("../controller/userController");

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/view", verifyUser, viewUser);

router.put("/changeProfilePicture", verifyUser, changeProfilePicture);

router.put("/changeEmail", verifyUser, changeEmail);

router.put("/changeProfileName", verifyUser, changeProfileName);

router.put("/changePassword", verifyUser, changePassword);

router.put("/changeGender", verifyUser, changeGender);

router.get("/progressPublication", verifyUser, publishProgress);

module.exports = router;
