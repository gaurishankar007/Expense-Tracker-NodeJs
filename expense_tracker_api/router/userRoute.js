// Importing installed packages.....
const express = require("express");
const router = new express.Router();
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const fs = require("fs");

// Importing self made js files....
const user = require("../model/userModel");
const progress = require("../model/progressModel");
const auth = require("../authentication/auth.js");
const profileUpload = require("../setting/profileSetting.js");

router.post("/user/register", (req, res) => {
  const email = req.body.email;
  const password = req.body.password;
  const confirmPassword = req.body.confirmPassword;
  const profileName = req.body.profileName;

  const passwordRegex = new RegExp(
    "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{5,15}$"
  );
  const emailRegex = new RegExp(
    "^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+"
  );
  const profileNameRegex = /^[a-zA-Z\s]*$/;

  if (
    email.trim() === "" ||
    password.trim() === "" ||
    profileName.trim() === ""
  ) {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!emailRegex.test(email)) {
    return res.status(400).send({ resM: "Invalid email address." });
  } else if (!profileNameRegex.test(profileName)) {
    return res.status(400).send({ resM: "Invalid profile name." });
  } else if (profileName.length <= 2 || profileName.length >= 21) {
    return res
      .status(400)
      .send({ resM: "Profile name most contain 3 to 20 characters." });
  } else if (!passwordRegex.test(password)) {
    return res.status(400).send({
      resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters.",
    });
  } else if (password !== confirmPassword) {
    return res.status(400).send({ resM: "Confirm password did not match." });
  }

  user.findOne({ email: email }).then(function (userData) {
    if (userData != null) {
      res
        .status(400)
        .send({ resM: "This email is already used, try another." });
      return;
    }

    bcryptjs.hash(password, 10, async function (e, hashed_value) {
      const newUser = await user.create({
        email: email,
        password: hashed_value,
        profileName: profileName,
      });

      const newProgress = new progress({
        user: newUser._id,
        badge: mongoose.Types.ObjectId("62c017a6e641bef273362a76"),
      });

      newProgress.save().then(() => {
        res.status(201).send({ resM: "Your account has been created." });
      });
    });
  });
});

router.post("/user/login", (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  user.findOne({ email: email }).then((userData1) => {
    if (userData1 == null) {
      return res
        .status(400)
        .send({ resM: "User with that email address does not exist." });
    }

    bcryptjs.compare(password, userData1.password, function (e, result) {
      if (!result) {
        res.status(400).send({ resM: "Incorrect password, try again." });
      } else {
        const token = jwt.sign({ userId: userData1._id }, "loginKey");
        if (userData1.admin) {
          res.status(202).send({
            token: token,
            resM: "Login success as admin.",
            userData: userData1,
          });
        } else {
          res.status(202).send({
            token: token,
            resM: "Login success.",
            userData: userData1,
          });
        }
      }
    });
  });
});

router.get("/user/view", auth.verifyUser, (req, res) => {
  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    res.send(userData);
  });
});

router.put(
  "/user/changeProfilePicture",
  auth.verifyUser,
  profileUpload.single("profile"),
  (req, res) => {
    if (req.file == undefined) {
      return res.status(400).send({
        resM: "Invalid image format, only supports png or jpeg image format.",
      });
    }

    user.findOne({ _id: req.userInfo._id }).then((userData) => {
      if (userData.profilePicture !== "user.png") {
        fs.unlinkSync(
          `../expense_tracker_api/upload/${userData.profilePicture}`
        );
      }

      user
        .updateOne(
          { _id: req.userInfo._id },
          { profilePicture: req.file.filename }
        )
        .then(() => {
          res.send({ resM: "Profile Picture Updated" });
        });
    });
  }
);

router.put("/user/changeEmail", auth.verifyUser, (req, res) => {
  const email = req.body.email;
  const emailRegex = new RegExp(
    "^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+"
  );

  if (email.trim() === "") {
    return res.status(400).send({ resM: "Provide email address." });
  } else if (!emailRegex.test(email)) {
    return res.status(400).send({ resM: "Invalid email address." });
  }

  user.findOne({ email: email }).then(function (userData) {
    if (userData != null) {
      return res
        .status(400)
        .send({ resM: "This email is already used, try another." });
    }
    user.updateOne({ _id: req.userInfo._id }, { email: email }).then(() => {
      res.send({ resM: "Your email has been changed." });
    });
  });
});

router.put("/user/changeProfileName", auth.verifyUser, (req, res) => {
  const profileName = req.body.profileName;

  if (profileName.trim() === "") {
    return res.status(400).send({ resM: "Provide profile name." });
  }

  user
    .updateOne({ _id: req.userInfo._id }, { profileName: profileName })
    .then(() => {
      res.send({ resM: "Your profile name has been changed." });
    });
});

router.put("/user/changePassword", auth.verifyUser, (req, res) => {
  const currentPassword = req.body.currentPassword;
  const newPassword = req.body.newPassword;

  const passwordRegex = new RegExp(
    "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{5,15}$"
  );

  if (currentPassword.trim() === "" || newPassword.trim() === "") {
    return res
      .status(400)
      .send({ resM: "Provide both current and new password." });
  } else if (currentPassword === newPassword) {
    return res
      .status(400)
      .send({ resM: "Current Password and New Password are Same" });
  } else if (!passwordRegex.test(newPassword)) {
    return res.status(400).send({
      resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters.",
    });
  }

  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    bcryptjs.compare(currentPassword, userData.password, function (e, result) {
      if (!result) {
        return res
          .status(400)
          .send({ resM: "Current Password did not match." });
      }
      bcryptjs.hash(newPassword, 10, (e, hashed_pass) => {
        user
          .updateOne({ _id: userData._id }, { password: hashed_pass })
          .then(() => {
            res.send({ resM: "Your password has been changed." });
          });
      });
    });
  });
});

router.put("/user/changeGender", auth.verifyUser, (req, res) => {
  const gender = req.body.gender;

  if (gender.trim() === "") {
    return res.status(400).send({ resM: "Gender not provided." });
  }

  user.updateOne({ _id: req.userInfo._id }, { gender: gender }).then(() => {
    res.send({ resM: "Your gender has been changed." });
  });
});

router.get("/user/progressPublication", auth.verifyUser, (req, res) => {
  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    user
      .updateOne(
        { _id: userData._id },
        { progressPublication: !userData.progressPublication }
      )
      .then(() => {
        if (userData.progressPublication) {
          res.send({ resM: "Progress made private." });
        } else {
          res.send({ resM: "Progress made public." });
        }
      });
  });
});

module.exports = router;
