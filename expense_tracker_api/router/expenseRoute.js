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

router.get("/expense/getDWM", auth.verifyUser, async (req, res) => {
  const currentDateTime = new Date();

  const today =
    (currentDateTime.getHours() * 60 * 60 +
      currentDateTime.getMinutes() * 60 +
      currentDateTime.getSeconds()) *
      1000 +
    currentDateTime.getMilliseconds();

  const currentDate = parseInt(
    currentDateTime.toISOString().split("T")[0].split("-")[2]
  );
  var weekFirstDate;
  var weekLastDate;

  if (currentDate <= 7) {
    weekFirstDate = "01";
    weekLastDate = "07";
  } else if (currentDate <= 14) {
    weekFirstDate = "08";
    weekLastDate = "14";
  } else if (currentDate <= 21) {
    weekFirstDate = "15";
    weekLastDate = "21";
  } else if (currentDate <= 28) {
    weekFirstDate = "22";
    weekLastDate = "28";
  } else if (currentDate < 35) {
    weekFirstDate = "29";
    weekLastDate = "31";
  }

  weekFirstDate = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-" +
        weekFirstDate
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  weekLastDate = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-" +
        weekLastDate
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const thisMonth = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-01"
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const todayExpenses = await expense
    .find({ createdAt: { $gte: new Date(Date.now() - today) } })
    .sort({ amount: -1 });

  var todayExpenseAmount = 0;
  for (let i = 0; i < todayExpenses.length; i++) {
    todayExpenseAmount = todayExpenseAmount + parseInt(todayExpenses[i].amount);
  }

  const thisWeekExpenses = await expense
    .find({
      createdAt: {
        $gte: weekFirstDate,
        $lte: weekLastDate,
      },
    })
    .sort({ amount: -1 });

  var thisWeekExpenseAmount = 0;
  for (let i = 0; i < thisWeekExpenses.length; i++) {
    thisWeekExpenseAmount =
      thisWeekExpenseAmount + parseInt(thisWeekExpenses[i].amount);
  }

  const thisMonthExpenses = await expense
    .find({ createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  var thisMonthExpenseAmount = 0;
  for (let i = 0; i < thisMonthExpenses.length; i++) {
    thisMonthExpenseAmount =
      thisMonthExpenseAmount + parseInt(thisMonthExpenses[i].amount);
  }

  const todayExpenseCategories = await expense.aggregate([
    { $match: { createdAt: { $gte: new Date(Date.now() - today) } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisWeekExpenseCategories = await expense.aggregate([
    { $match: { createdAt: { $gte: weekFirstDate, $lte: weekLastDate } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisMonthExpenseCategories = await expense.aggregate([
    { $match: { createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const firstExpense = await expense.findOne().sort({ createdAt: 1 });

  res.send({
    profilePicture: req.userInfo.profilePicture,
    firstExpenseDate: firstExpense.createdAt.toISOString().split("T")[0],
    todayExpenses: todayExpenses,
    thisWeekExpenses: thisWeekExpenses,
    thisMonthExpenses: thisMonthExpenses,
    todayExpenseAmount: todayExpenseAmount,
    thisWeekExpenseAmount: thisWeekExpenseAmount,
    thisMonthExpenseAmount: thisMonthExpenseAmount,
    todayExpenseCategories: todayExpenseCategories,
    thisWeekExpenseCategories: thisWeekExpenseCategories,
    thisMonthExpenseCategories: thisMonthExpenseCategories,
  });
});

router.post("/expense/getSpecific", async (req, res) => {
  const sDate = req.body.startDate;
  const eDate = req.body.endDate;

  if (sDate.trim() === "" || eDate.trim() === "") {
    return res.send({ resM: "Provide both start and end date." });
  }

  const currentDateTime = new Date();

  startDate = new Date(
    new Date(sDate).getTime() + currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  endDate = new Date(
    new Date(eDate).getTime() + currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const expenses = await expense
    .find({
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    })
    .sort({ amount: -1 });

  var expenseAmount = 0;
  for (let i = 0; i < expenses.length; i++) {
    expenseAmount = expenseAmount + parseInt(expenses[i].amount);
  }

  const expenseCategories = await expense.aggregate([
    {
      $match: {
        createdAt: {
          $gte: startDate,
          $lte: endDate,
        },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  res.send({
    expenses: expenses,
    expenseAmount: expenseAmount,
    expenseCategories: expenseCategories,
  });
});

router.delete("/expense/remove", (req, res) => {
  expense.findOneAndDelete({ _id: req.body.expenseId }).then(() => {
    res.send({ resM: "Expense removed." });
  });
});

router.put("/expense/edit", (req, res) => {
  const expenseId = req.body.expenseId;
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

  expense
    .updateOne(
      { _id: expenseId },
      {
        name: name,
        amount: amount,
        category: category,
      }
    )
    .then(() => {
      res.send({ resM: "Expense edited." });
    });
});

module.exports = router;
