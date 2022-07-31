const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const progress = require("../model/progressModel");
const achievement = require("../model/achievementModel");
const user = require("../model/userModel");
const expense = require("../model/expenseModel");
const income = require("../model/incomeModel");

const userProgress = asyncHandler(async (req, res) => {
  const userProgress = await progress
    .findOne({ user: req.userInfo._id })
    .populate(
      "user",
      "email profileName profilePicture gender profilePublication"
    )
    .populate("oldAchievement", "name description")
    .populate("newAchievement", "name description");

  res.send({ progress: userProgress });
});

const usersProgress = asyncHandler(async (req, res) => {
  const users = await user.find({ progressPublication: true });

  const progressPoints = await progress
    .find({ user: { $in: users } })
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ progress: -1 })
    .limit(20);

  const tmpPoints = await progress
    .find({ user: { $in: users } })
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ tmp: -1 })
    .limit(20);

  const pmpPoints = await progress
    .find({ user: { $in: users } })
    .populate("user")
    .populate("oldAchievement")
    .populate("newAchievement")
    .sort({ pmp: -1 })
    .limit(20);

  res.send({
    progressPoints: progressPoints,
    tmpPoints: tmpPoints,
    pmpPoints: pmpPoints,
  });
});

const userCalculateProgress = asyncHandler(async (req, res) => {
  const userProgress = await progress.findOne({ user: req.userInfo._id });
  const progressCalMonth = parseInt(
    userProgress.pmc.toISOString().split("T")[0].split("-")[1]
  );

  const month28 = [2];
  const month30 = [4, 6, 9, 11];
  const month31 = [1, 3, 5, 7, 8, 10, 12];

  const currentDate = new Date();
  var previousMonthDate = 0;
  
  if (
    month28.includes(
      parseInt(currentDate.toISOString().split("T")[0].split("-")[1])
    )
  ) {
    const leap =
      new Date(
        parseInt(currentDate.toISOString().split("T")[0].split("-")[0]),
        1,
        29
      ).getDate() === 29;
    if (leap) {
      previousMonthDate = new Date(currentDate.getTime() - 2505600000);
    } else {
      previousMonthDate = new Date(currentDate.getTime() - 2419200000);
    }
  } else if (
    month30.includes(
      parseInt(currentDate.toISOString().split("T")[0].split("-")[1])
    )
  ) {
    previousMonthDate = new Date(currentDate.getTime() - 2592000000);
  } else {
    previousMonthDate = new Date(currentDate.getTime() - 2678400000);
  }
  const previousMonth = parseInt(
    previousMonthDate.toISOString().split("T")[0].split("-")[1]
  );

  if (progressCalMonth === previousMonth) {
    res.send({
      resM: "Progress is not ready to be calculated yet.",
      achievementUnlocked: false,
    });
  } else if (progressCalMonth < previousMonth) {
    const tm = new Date(
      new Date(
        currentDate.toISOString().split("T")[0].split("-")[0] +
          "-" +
          currentDate.toISOString().split("T")[0].split("-")[1] +
          "-01"
      ).getTime() +
        currentDate.getTimezoneOffset() * 60 * 1000
    );
    const pm = new Date(tm.getTime() - 2592000000);

    const expenses = await expense.find({
      user: req.userInfo._id,
      createdAt: { $gte: pm, $lte: tm },
    });
    const incomes = await income.find({
      user: req.userInfo._id,
      createdAt: { $gte: pm, $lte: tm },
    });

    const expenseDays = [];
    var expenseAmount = 0;

    for (let i = 0; i < expenses.length; i++) {
      expenseAmount = expenseAmount + expenses[i].amount;

      const day = parseInt(
        expenses[i].createdAt.toISOString().split("T")[0].split("-")[2]
      );

      if (!expenseDays.includes(day)) {
        expenseDays.push(day);
      }
    }

    const incomeDays = [];
    var incomeAmount = 0;

    for (let i = 0; i < incomes.length; i++) {
      incomeAmount = incomeAmount + incomes[i].amount;

      const day = parseInt(
        incomes[i].createdAt.toISOString().split("T")[0].split("-")[2]
      );

      if (!incomeDays.includes(day)) {
        incomeDays.push(day);
      }
    }

    const saving = ((incomeAmount - expenseAmount) / incomeAmount) * 100;

    const achievementIds = [];
    var achievementUnlocked = false;

    if (expenseDays.length >= 29) {
      achievementUnlocked = true;
      achievementIds.push(mongoose.Types.ObjectId("62c01e212744425ef8f43030"));
    }
    if (incomeDays.length >= 29) {
      achievementUnlocked = true;
      achievementIds.push(mongoose.Types.ObjectId("62c01e4e2744425ef8f43033"));
    }
    if (saving > 25) {
      achievementUnlocked = true;
      achievementIds.push(mongoose.Types.ObjectId("62cf73c317d764d0c6ef5302"));
    }
    if (saving > 50) {
      achievementUnlocked = true;
      achievementIds.push(mongoose.Types.ObjectId("62c01f8b2744425ef8f4303f"));
    }
    if (saving > 75) {
      achievementUnlocked = true;
      achievementIds.push(mongoose.Types.ObjectId("62c01f612744425ef8f4303c"));
    }

    const newAchievements = await achievement.find({
      _id: { $in: achievementIds },
    });

    var newProgressPoint = 0;
    for (let i = 0; i < newAchievements.length; i++) {
      newProgressPoint = newProgressPoint + newAchievements[i].progressPoint;
    }

    for (let i = 0; i < userProgress.newAchievement.length; i++) {
      achievementIds.push(userProgress.newAchievement[i]);
    }

    const totalProgress = newProgressPoint + userProgress.progress;
    const totalProgressPoint = newProgressPoint + userProgress.tmp;

    progress
      .updateOne(
        { user: req.userInfo._id },
        {
          progress: totalProgress,
          tmp: 0,
          pmp: totalProgressPoint,
          newAchievement: [],
          oldAchievement: achievementIds,
          pmc: previousMonthDate,
        }
      )
      .then(() => {
        res.send({
          resM: "Previous month progress calculated.",
          achievementUnlocked: achievementUnlocked,
        });
      });
  }
});

module.exports = { userProgress, usersProgress, userCalculateProgress };
