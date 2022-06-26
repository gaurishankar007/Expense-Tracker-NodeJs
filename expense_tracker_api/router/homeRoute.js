const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const user = require("../model/userModel");
const expense = require("../model/expenseModel");
const income = require("../model/incomeModel");

router.get("/user/getHome", auth.verifyUser, async (req, res) => {
  const currentDateTime = new Date();

  const thisMonth = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-01"
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const previousMonth = new Date(thisMonth.getTime() - 2592000000);

  const thisMonthExpenses = await expense
    .find({ user: req.userInfo._id, createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  const thisMonthIncomes = await income
    .find({ user: req.userInfo._id, createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  var thisMonthExpenseAmount = 0;
  const maxExpenseCategory = { _id: "Nan", amount: -1 };
  const thisMonthExpenseCategories = await expense.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);
  for (let i = 0; i < thisMonthExpenseCategories.length; i++) {
    thisMonthExpenseAmount =
      thisMonthExpenseAmount + thisMonthExpenseCategories[i].amount;
    if (thisMonthExpenseCategories[i].amount > maxExpenseCategory.amount) {
      maxExpenseCategory._id = thisMonthExpenseCategories[i]._id;
      maxExpenseCategory.amount = thisMonthExpenseCategories[i].amount;
    }
  }

  var thisMonthIncomeAmount = 0;
  const maxIncomeCategory = { _id: "Nan", amount: 0 };
  const thisMonthIncomeCategories = await income.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);
  for (let i = 0; i < thisMonthIncomeCategories.length; i++) {
    thisMonthIncomeAmount =
      thisMonthIncomeAmount + thisMonthIncomeCategories[i].amount;
    if (thisMonthIncomeCategories[i].amount > maxIncomeCategory.amount) {
      maxIncomeCategory._id = thisMonthIncomeCategories[i]._id;
      maxIncomeCategory.amount = thisMonthIncomeCategories[i].amount;
    }
  }

  const previousMonthExpenseAmount = await expense.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: previousMonth, $lte: thisMonth },
      },
    },
    {
      $group: { _id: null, amount: { $sum: "$amount" } },
    },
  ]);

  const previousMonthIncomeAmount = await income.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: previousMonth, $lte: thisMonth },
      },
    },
    {
      $group: { _id: null, amount: { $sum: "$amount" } },
    },
  ]);

  const month1 = [4, 6, 9, 11];
  const month2 = [1, 3, 5, 7, 8, 10, 12];

  var previousMonthDays;
  if (month1.includes(parseInt(currentDateTime.getMonth()))) {
    previousMonthDays = 30;
  } else if (month2.includes(parseInt(currentDateTime.getMonth()))) {
    previousMonthDays = 31;
  } else {
    previousMonthDays = 28;
  }

  const thisMonthExpenseRate = parseFloat(
    (thisMonthExpenseAmount / parseInt(currentDateTime.getDate())).toFixed(2)
  );

  const thisMonthIncomeRate = parseFloat(
    (thisMonthIncomeAmount / parseInt(currentDateTime.getDate())).toFixed(2)
  );

  const previousMonthExpenseRate = parseFloat(
    (previousMonthExpenseAmount[0].amount / previousMonthDays).toFixed(2)
  );

  const previousMonthIncomeRate = parseFloat(
    (previousMonthIncomeAmount[0].amount / previousMonthDays).toFixed(2)
  );

  res.send({
    thisMonthExpenses: thisMonthExpenses,
    thisMonthIncomes: thisMonthIncomes,
    thisMonthExpenseAmount: thisMonthExpenseAmount,
    thisMonthIncomeAmount: thisMonthIncomeAmount,
    maxExpenseCategory: maxExpenseCategory,
    maxIncomeCategory: maxIncomeCategory,
    previousMonthExpenseAmount: previousMonthExpenseAmount[0].amount,
    previousMonthIncomeAmount: previousMonthIncomeAmount[0].amount,
    thisMonthExpenseRate: thisMonthExpenseRate,
    thisMonthIncomeRate: thisMonthIncomeRate,
    previousMonthExpenseRate: previousMonthExpenseRate,
    previousMonthIncomeRate: previousMonthIncomeRate,
  });
});

module.exports = router;
