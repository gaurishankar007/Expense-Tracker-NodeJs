const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const expense = require("../model/expenseModel");
const progress = require("../model/progressModel");
const achievement = require("../model/achievementModel");

const addExpense = asyncHandler(async (req, res) => {
  const { name, amount, category } = req.body;

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

  await expense.create({
    user: req.userInfo._id,
    name: name,
    amount: amount,
    category: category,
  });

  const userProgress = await progress.findOne({ user: req.userInfo._id });
  await progress.updateOne(
    { user: req.userInfo._id },
    {
      progress: userProgress.progress + 10,
      tmp: userProgress.tmp + 10,
    }
  );

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

  const totalExpenses = await expense.count({
    user: req.userInfo._id,
    createdAt: { $gte: thisMonth },
  });

  const achievementIds = userProgress.newAchievement;
  var achievementUnlocked = false;

  if (
    totalExpenses > 30 &&
    achievementIds.includes("62cf738317d764d0c6ef52ff") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62cf738317d764d0c6ef52ff"));
    const newAchievement = await achievement.findOne({
      _id: "62cf738317d764d0c6ef52ff",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 10;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalExpenses > 100 &&
    achievementIds.includes("62c01ecc2744425ef8f43036") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62c01ecc2744425ef8f43036"));
    const newAchievement = await achievement.findOne({
      _id: "62c01ecc2744425ef8f43036",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 10;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalExpenses > 200 &&
    achievementIds.includes("62c01ed62744425ef8f43039") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62c01ed62744425ef8f43039"));
    const newAchievement = await achievement.findOne({
      _id: "62c01ed62744425ef8f43039",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 10;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  }

  res.status(201);
  res.json({
    resM: "Expense added.",
    achievementUnlocked: achievementUnlocked,
  });
});

const getDWMExpenses = asyncHandler(async (req, res) => {
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
    weekLastDate = "08";
  } else if (currentDate <= 14) {
    weekFirstDate = "08";
    weekLastDate = "15";
  } else if (currentDate <= 21) {
    weekFirstDate = "15";
    weekLastDate = "22";
  } else if (currentDate <= 28) {
    weekFirstDate = "22";
    weekLastDate = "29";
  } else if (currentDate < 32) {
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

  if(currentDate > 28 ) {
    weekLastDate = new Date(weekLastDate.getTime() + 86400000 )
  }

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
    .find({
      user: req.userInfo._id,
      createdAt: { $gte: new Date(Date.now() - today) },
    })
    .sort({ amount: -1 });

  var todayExpenseAmount = 0;
  for (let i = 0; i < todayExpenses.length; i++) {
    todayExpenseAmount = todayExpenseAmount + parseInt(todayExpenses[i].amount);
  }

  const thisWeekExpenses = await expense
    .find({
      user: req.userInfo._id,
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
    .find({ user: req.userInfo._id, createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  var thisMonthExpenseAmount = 0;
  for (let i = 0; i < thisMonthExpenses.length; i++) {
    thisMonthExpenseAmount =
      thisMonthExpenseAmount + parseInt(thisMonthExpenses[i].amount);
  }

  const todayExpenseCategories = await expense.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: new Date(Date.now() - today) },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisWeekExpenseCategories = await expense.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: weekFirstDate, $lte: weekLastDate },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisMonthExpenseCategories = await expense.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const firstExpense = await expense
    .findOne({ user: req.userInfo._id })
    .sort({ createdAt: 1 });

  const firstExpenseDate =
    firstExpense === null
      ? currentDateTime.toISOString().split("T")[0]
      : firstExpense.createdAt.toISOString().split("T")[0];

  res.send({
    profilePicture: req.userInfo.profilePicture,
    firstExpenseDate: firstExpenseDate,
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

const getSpecificExpenses = asyncHandler(async (req, res) => {
  const sDate = req.body.startDate;
  const eDate = req.body.endDate;

  if (sDate.trim() === "" || eDate.trim() === "") {
    return res.status(400).send({ resM: "Provide both start and end date." });
  }

  const currentDateTime = new Date();

  const startDate = new Date(
    new Date(sDate).getTime() + currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const endDate = new Date(
    new Date(eDate).getTime() +
      24 * 60 * 60 * 1000 +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const expenses = await expense
    .find({
      user: req.userInfo._id,
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
        user: req.userInfo._id,
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

const removeExpense = asyncHandler(async (req, res) => {
  await expense.findOneAndDelete({ _id: req.body.expenseId });
  const userProgress = await progress.findOne({ user: req.userInfo._id });

  await progress.updateOne(
    { user: req.userInfo._id },
    {
      progress: userProgress.progress - 10,
      tmp: userProgress.tmp - 10,
    }
  );

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

  const totalExpenses = await expense.count({
    user: req.userInfo._id,
    createdAt: { $gte: thisMonth },
  });

  const achievementIds = userProgress.newAchievement;

  if (
    totalExpenses <= 200 &&
    achievementIds.includes("62c01ed62744425ef8f43039")
  ) {
    aId = achievementIds.indexOf("62c01ed62744425ef8f43039");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62c01ed62744425ef8f43039",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 10;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalExpenses <= 100 &&
    achievementIds.includes("62c01ecc2744425ef8f43036")
  ) {
    aId = achievementIds.indexOf("62c01ecc2744425ef8f43036");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62c01ecc2744425ef8f43036",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 10;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalExpenses <= 30 &&
    achievementIds.includes("62cf738317d764d0c6ef52ff")
  ) {
    aId = achievementIds.indexOf("62cf738317d764d0c6ef52ff");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62cf738317d764d0c6ef52ff",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 10;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 10;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  }

  res.send({ resM: "Expense removed." });
});

const editExpense = (req, res) => {
  const { expenseId, name, amount, category } = req.body;

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
};

const getCategorizedExpenses = asyncHandler(async (req, res) => {
  const category = req.body.category;

  if (category.trim() === "") {
    return res.send({ resM: "Provide expense category." });
  }

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

  const thisMonthExpenses = await expense
    .find({
      user: req.userInfo._id,
      category: category,
      createdAt: { $gte: thisMonth },
    })
    .sort({ amount: -1 });

  res.send(thisMonthExpenses);
});

const getSpecificallyCategorizedExpenses = asyncHandler(async (req, res) => {
  const category = req.body.category;
  const sDate = req.body.startDate;
  const eDate = req.body.endDate;

  if (category.trim() === "" || sDate.trim() === "" || eDate.trim() === "") {
    return res
      .status(400)
      .send({ resM: "Provide both start and end date along with category." });
  }

  const currentDateTime = new Date();

  const startDate = new Date(
    new Date(sDate).getTime() + currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const endDate = new Date(
    new Date(eDate).getTime() +
      24 * 60 * 60 * 1000 +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const thisMonthExpenses = await expense
    .find({
      user: req.userInfo._id,
      category: category,
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    })
    .sort({ amount: -1 });

  res.send(thisMonthExpenses);
});

const getCategorizedExpenseStartDate = asyncHandler(async (req, res) => {
  const category = req.body.category;

  if (category.trim() === "") {
    return res.send({ resM: "Provide expense category." });
  }

  const firstExpenseCategory = await expense
    .findOne({
      user: req.userInfo._id,
      category: category,
    })
    .sort({ createdAt: 1 });

  const currentDateTime = new Date();

  const startDate =
    firstExpenseCategory === null
      ? currentDateTime.toISOString().split("T")[0]
      : firstExpenseCategory.createdAt.toISOString().split("T")[0];

  res.send(startDate);
});

module.exports = {
  addExpense,
  getDWMExpenses,
  getSpecificExpenses,
  removeExpense,
  editExpense,
  getCategorizedExpenses,
  getSpecificallyCategorizedExpenses,
  getCategorizedExpenseStartDate,
};
