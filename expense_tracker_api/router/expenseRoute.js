const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const user = require("../model/userModel");
const expense = require("../model/expenseModel");

router.post("/expense/add", auth.verifyUser, (req, res) => {
  const name = req.body.name;
  const amount = req.body.amount;
  const category = req.body.category;

  const nameRegex = /^[a-zA-Z\s]*$/;
  const amountRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || amount.trim() === "" || category.trim() === "") {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!nameRegex.test(name)) {
    return res.status(400).send({ resM: "Invalid expense name." });
  } else if (name.length <= 2 || name.length >= 16) {
    return res
      .status(400)
      .send({ resM: "Expense name most contain 3 to 15 characters." });
  } else if (!amountRegex.test(amount)) {
    return res.status(400).send({ resM: "Invalid amount." });
  } else if (amount.length >= 8) {
    return res
      .status(400)
      .send({ resM: "Expense amount most be less than one crore" });
  }

  const newExpense = new expense({
    user: req.userInfo._id,
    name: name,
    amount: amount,
    category: category,
  });

  newExpense.save().then(() => {
    res.status(201).send({ resM: "Expense added." });
  });
});

module.exports = router;
