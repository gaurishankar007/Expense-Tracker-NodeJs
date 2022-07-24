const asyncHandler = require("express-async-handler");
const expense = require("../model/expenseModel");
const income = require("../model/incomeModel");

const userHomeData = asyncHandler(async (req, res) => {
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
    .find({
      user: req.userInfo._id,
      createdAt: { $gte: thisMonth },
    })
    .sort({ createdAt: 1 });

  const previousMonthExpenses = await expense
    .find({
      user: req.userInfo._id,
      createdAt: { $gte: previousMonth, $lte: thisMonth },
    })
    .sort({ createdAt: 1 });

  var thisMonthView = true;
  const expenseDays = [];
  const expenseAmounts = [];

  for (let i = 0; i < thisMonthExpenses.length; i++) {
    const day = parseInt(
      thisMonthExpenses[i].createdAt.toISOString().split("T")[0].split("-")[2]
    );

    if (!expenseDays.includes(day)) {
      expenseDays.push(day);
      expenseAmounts.push(thisMonthExpenses[i].amount);
    } else {
      const newIndex = expenseDays.indexOf(day);
      const newExpenseAmount =
        expenseAmounts[newIndex] + thisMonthExpenses[i].amount;
      expenseAmounts[newIndex] = newExpenseAmount;
    }
  }

  if (expenseDays.length <= 2) {
    thisMonthView = false;
    expenseDays.splice(0, expenseDays.length);
    expenseAmounts.splice(0, expenseAmounts.length);

    for (let i = 0; i < previousMonthExpenses.length; i++) {
      const day = parseInt(
        previousMonthExpenses[i].createdAt
          .toISOString()
          .split("T")[0]
          .split("-")[2]
      );

      if (!expenseDays.includes(day)) {
        expenseDays.push(day);
        expenseAmounts.push(previousMonthExpenses[i].amount);
      } else {
        const newIndex = expenseDays.indexOf(day);
        const newExpenseAmount =
          expenseAmounts[newIndex] + previousMonthExpenses[i].amount;
        expenseAmounts[newIndex] = newExpenseAmount;
      }
    }
  }

  var maxExpenseAmount = 0;
  for (let i = 0; i < expenseAmounts.length; i++) {
    if (expenseAmounts[i] > maxExpenseAmount) {
      maxExpenseAmount = expenseAmounts[i];
    }
  }

  var thisMonthExpenseAmount = 0;
  const thisMonthExpenseCategories = await expense.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
    { $sort: { amount: -1 } },
  ]);
  for (let i = 0; i < thisMonthExpenseCategories.length; i++) {
    thisMonthExpenseAmount =
      thisMonthExpenseAmount + thisMonthExpenseCategories[i].amount;
  }

  var thisMonthIncomeAmount = 0;
  const thisMonthIncomeCategories = await income.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
    { $sort: { amount: -1 } },
  ]);
  for (let i = 0; i < thisMonthIncomeCategories.length; i++) {
    thisMonthIncomeAmount =
      thisMonthIncomeAmount + thisMonthIncomeCategories[i].amount;
  }

  const previousMonthExpenseCategory = await expense.aggregate([
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

  const previousMonthIncomeCategory = await income.aggregate([
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

  const previousMonthExpenseAmount =
    previousMonthExpenseCategory.length == 0
      ? 0
      : previousMonthExpenseCategory[0].amount;
  const previousMonthIncomeAmount =
    previousMonthIncomeCategory.length == 0
      ? 0
      : previousMonthIncomeCategory[0].amount;

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
    (previousMonthExpenseAmount / previousMonthDays).toFixed(2)
  );

  const previousMonthIncomeRate = parseFloat(
    (previousMonthIncomeAmount / previousMonthDays).toFixed(2)
  );
  res.send({
    thisMonthView: thisMonthView,
    expenseDays: expenseDays,
    expenseAmounts: expenseAmounts,
    maxExpenseAmount: maxExpenseAmount,
    thisMonthExpenseAmount: thisMonthExpenseAmount,
    thisMonthIncomeAmount: thisMonthIncomeAmount,
    previousMonthExpenseAmount: previousMonthExpenseAmount,
    previousMonthIncomeAmount: previousMonthIncomeAmount,
    thisMonthExpenseCategories: thisMonthExpenseCategories,
    thisMonthIncomeCategories: thisMonthIncomeCategories,
  });
});

module.exports = { userHomeData };
