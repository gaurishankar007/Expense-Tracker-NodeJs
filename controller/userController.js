const asyncHandler = require("express-async-handler");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
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

    const currentDate = new Date();
    const previousMonth = new Date(currentDate.getTime() - 2592000000);

    bcryptjs.hash(password, 10, async function (e, hashed_value) {
      const newUser = await user.create({
        email: email,
        password: hashed_value,
        profileName: profileName,
        passReset: currentDate,
      });

      const newProgress = new progress({
        user: newUser._id,
        pmc: previousMonth,
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

        res.status(202).send({
          token: token,
          resM: "Login success.",
          userData: userData1,
        });
      }
    });
  });
};

const googleSignIn = asyncHandler(async (req, res) => {
  const { email, profilePicture, profileName } = req.body;

  const userData = await user.findOne({ email: email });
  if (userData != null) {
    const userData = await user.findOne({ email: email });
    const token = jwt.sign({ userId: userData._id }, "loginKey");
    res.status(202).send({
      token: token,
      resM: "Login success.",
      userData: userData,
    });
  } else {
    const currentDate = new Date();
    const previousMonth = new Date(currentDate.getTime() - 2592000000);

    const newUser = await user.create({
      email: email,
      password: "google",
      profilePicture: profilePicture,
      profileName: profileName,
    });

    await progress.create({
      user: newUser._id,
      pmc: previousMonth,
    });

    const token = jwt.sign({ userId: newUser._id }, "loginKey");
    res.status(202).send({
      token: token,
      resM: "Login success.",
      userData: newUser,
    });
  }
});

const checkPassword = (req, res) => {
  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    var changePassword = false;

    if (userData.passReset !== null) {
      const currentDate = new Date();
      const time = currentDate.getTime() - userData.passReset.getTime();
      changePassword = time > 5184000000 ? true : false;
    }

    res.send(changePassword);
  });
};

const viewUser = (req, res) => {
  user.findOne({ _id: req.userInfo._id }).then((userData) => {
    res.send(userData);
  });
};

const changeProfilePicture = asyncHandler(async (req, res) => {
  if (req.file == undefined) {
    return res.status(400).send({
      resM: "Invalid image format, only supports png or jpeg image format.",
    });
  }

  const userData = await user.findOne({ _id: req.userInfo._id });
  if (
    userData.profilePicture !==
    "https://res.cloudinary.com/gaurishankar/image/upload/v1658148482/ExpenseTracker/p3o8edl8jnwvdhk5xjmx.png"
  ) {
    const result = await cloudinary.uploader.destroy(
      "ExpenseTracker/" +
        userData.profilePicture.split("ExpenseTracker/")[1].split(".")[0]
    );
  }

  user
    .updateOne({ _id: req.userInfo._id }, { profilePicture: req.file.path })
    .then(() => {
      res.send({ resM: "Profile Picture Updated" });
    });
});

const changeProfileInfo = asyncHandler(async (req, res) => {
  const { email, profileName, gender } = req.body;

  const emailRegex = new RegExp(
    "^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+"
  );
  const profileNameRegex = /^[a-zA-Z\s]*$/;

  if (
    email.trim() === "" ||
    profileName.trim() === "" ||
    gender.trim() === ""
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
  }

  const userData = await user.findOne({ email: email });
  if (userData != null && email != req.userInfo.email) {
    return res
      .status(400)
      .send({ resM: "This email is already used, try another." });
  }

  user
    .updateOne(
      { _id: req.userInfo._id },
      { email: email, profileName: profileName, gender: gender }
    )
    .then(() => {
      res.send({ resM: "Profile information updated." });
    });
});

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
        const currentDate = new Date();
        user
          .updateOne(
            { _id: userData._id },
            { password: hashed_pass, passReset: currentDate }
          )
          .then(() => {
            res.send({ resM: "Your password has been changed." });
          });
      });
    });
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
  googleSignIn,
  checkPassword,
  viewUser,
  changeProfilePicture,
  changeProfileInfo,
  changePassword,
  publishProgress,
};
