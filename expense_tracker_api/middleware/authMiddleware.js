const jwt = require("jsonwebtoken");
const user = require("../model/userModel.js");

const verifyUser = function (req, res, next) {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const userData = jwt.verify(token, "loginKey");
    user
      .findOne({ _id: userData.userId })
      .then((userDetail) => {
        req.userInfo = userDetail;
        next();
      })
      .catch(function (error) {
        res.status(400).send({ resM: error });
      });
  } catch (error) {
    res.status(401).send({ resM: "Invalid Token!" });
  }
};

module.exports = { verifyUser };
