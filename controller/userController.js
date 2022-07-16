const asyncHandler = require("express-async-handler");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const fsExtra = require("fs-extra");
const { cloudinary } = require("../utils/cloudinary");
const user = require("../model/userModel");
const progress = require("../model/progressModel");

const registerUser = (req, res) => {
  const { email, password, confirmPassword, profileName } = req.body;

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
      });

      newProgress.save().then(() => {
        res.status(201).send({ resM: "Your account has been created." });
      });
    });
  });
};

const loginUser = (req, res) => {
  const { email, password } = req.body;

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
};

const viewUser = (req, res) => {
  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    res.send(userData);
  });
};

const changeProfilePicture = asyncHandler(async (req, res) => {
  const file = req.files.profile;

  if (
    file.mimetype == "image/png" ||
    file.mimetype == "image/jpeg" ||
    file.mimetype == "application/octet-stream"
  ) {
    const cloudinaryUploader = await cloudinary.uploader.upload(
      file.tempFilePath,
      {
        upload_preset: "expense_income_tracker",
      }
    );

    user.findOne({ _id: req.userInfo._id }).then((userData) => {
      if (userData.profilePicture !== "https://res.cloudinary.com/gaurishankar/image/upload/v1657982085/xstpveuuak5kzekmmm9y.png") {
      }

      fsExtra.emptyDirSync("../Expense-Tracker-API/tmp");

      user
        .updateOne(
          { _id: req.userInfo._id },
          { profilePicture: cloudinaryUploader.url }
        )
        .then(() => {
          res.send({ resM: "Profile Picture Updated" });
        });
    });
  } else {
    return res.status(400).send({
      resM: "Invalid image format, only supports only one png or jpeg image format.",
    });
  }
});

const changeEmail = (req, res) => {
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
};

const changeProfileName = (req, res) => {
  const profileName = req.body.profileName;

  if (profileName.trim() === "") {
    return res.status(400).send({ resM: "Provide profile name." });
  }

  user
    .updateOne({ _id: req.userInfo._id }, { profileName: profileName })
    .then(() => {
      res.send({ resM: "Your profile name has been changed." });
    });
};

const changePassword = (req, res) => {
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
};

const changeGender = (req, res) => {
  const gender = req.body.gender;

  if (gender.trim() === "") {
    return res.status(400).send({ resM: "Gender not provided." });
  }

  user.updateOne({ _id: req.userInfo._id }, { gender: gender }).then(() => {
    res.send({ resM: "Your gender has been changed." });
  });
};

const publishProgress = (req, res) => {
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
};

module.exports = {
  registerUser,
  loginUser,
  viewUser,
  changeProfilePicture,
  changeEmail,
  changeProfileName,
  changePassword,
  changeGender,
  publishProgress,
};
