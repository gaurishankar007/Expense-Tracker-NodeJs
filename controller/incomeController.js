const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const income = require("../model/incomeModel");
const progress = require("../model/progressModel");
const achievement = require("../model/achievementModel");

const addIncome = asyncHandler(async (req, res) => {
  const { name, amount, category } = req.body;

  const nameRegex = /^[a-zA-Z\s]*$/;
  const amountRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || amount.trim() === "" || category.trim() === "") {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!nameRegex.test(name)) {
    return res.status(400).send({ resM: "Invalid income name." });
  } else if (name.length <= 2 || name.length >= 16) {
    return res
      .status(400)
      .send({ resM: "Income name most contain 3 to 15 characters." });
  } else if (!amountRegex.test(amount)) {
    return res.status(400).send({ resM: "Invalid amount." });
  } else if (amount.length >= 8) {
    return res
      .status(400)
      .send({ resM: "Income amount most be less than one crore" });
  }

  await income.create({
    user: req.userInfo._id,
    name: name,
    amount: amount,
    category: category,
  });

  const userProgress = await progress.findOne({ user: req.userInfo._id });
  await progress.updateOne(
    { user: req.userInfo._id },
    {
      progress: userProgress.progress + 15,
      tmp: userProgress.tmp + 15,
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

  const totalIncomes = await income.count({
    user: req.userInfo._id,
    createdAt: { $gte: thisMonth },
  });

  const achievementIds = userProgress.newAchievement;
  var achievementUnlocked = false;

  if (
    totalIncomes > 30 &&
    achievementIds.includes("62cf736317d764d0c6ef52fc") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62cf736317d764d0c6ef52fc"));
    const newAchievement = await achievement.findOne({
      _id: "62cf736317d764d0c6ef52fc",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 15;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 15;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalIncomes > 100 &&
    achievementIds.includes("62c0202d2744425ef8f43042") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62c0202d2744425ef8f43042"));
    const newAchievement = await achievement.findOne({
      _id: "62c0202d2744425ef8f43042",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 15;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 15;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalIncomes > 200 &&
    achievementIds.includes("62cc26c437473374a8eed577") == false
  ) {
    achievementUnlocked = true;
    achievementIds.push(mongoose.Types.ObjectId("62cc26c437473374a8eed577"));
    const newAchievement = await achievement.findOne({
      _id: "62cc26c437473374a8eed577",
    });
    const newProgressPoint = newAchievement.progressPoint;

    const totalProgress = newProgressPoint + userProgress.progress + 15;
    const totalProgressPoint = newProgressPoint + userProgress.tmp + 15;

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
  res.json({ resM: "Income added.", achievementUnlocked: achievementUnlocked });
});

const getDWMIncomes = asyncHandler(async (req, res) => {
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

  const todayIncomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: { $gte: new Date(Date.now() - today) },
    })
    .sort({ amount: -1 });

  var todayIncomeAmount = 0;
  for (let i = 0; i < todayIncomes.length; i++) {
    todayIncomeAmount = todayIncomeAmount + parseInt(todayIncomes[i].amount);
  }

  const thisWeekIncomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: {
        $gte: weekFirstDate,
        $lte: weekLastDate,
      },
    })
    .sort({ amount: -1 });

  var thisWeekIncomeAmount = 0;
  for (let i = 0; i < thisWeekIncomes.length; i++) {
    thisWeekIncomeAmount =
      thisWeekIncomeAmount + parseInt(thisWeekIncomes[i].amount);
  }

  const thisMonthIncomes = await income
    .find({ user: req.userInfo._id, createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  var thisMonthIncomeAmount = 0;
  for (let i = 0; i < thisMonthIncomes.length; i++) {
    thisMonthIncomeAmount =
      thisMonthIncomeAmount + parseInt(thisMonthIncomes[i].amount);
  }

  const todayIncomeCategories = await income.aggregate([
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

  const thisWeekIncomeCategories = await income.aggregate([
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

  const thisMonthIncomeCategories = await income.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const firstIncome = await income
    .findOne({ user: req.userInfo._id })
    .sort({ createdAt: 1 });

  const firstIncomeDate =
    firstIncome === null
      ? currentDateTime.toISOString().split("T")[0]
      : firstIncome.createdAt.toISOString().split("T")[0];

  res.send({
    profilePicture: req.userInfo.profilePicture,
    firstIncomeDate: firstIncomeDate,
    todayIncomes: todayIncomes,
    thisWeekIncomes: thisWeekIncomes,
    thisMonthIncomes: thisMonthIncomes,
    todayIncomeAmount: todayIncomeAmount,
    thisWeekIncomeAmount: thisWeekIncomeAmount,
    thisMonthIncomeAmount: thisMonthIncomeAmount,
    todayIncomeCategories: todayIncomeCategories,
    thisWeekIncomeCategories: thisWeekIncomeCategories,
    thisMonthIncomeCategories: thisMonthIncomeCategories,
  });
});

const getSpecificIncomes = asyncHandler(async (req, res) => {
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

  const incomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    })
    .sort({ amount: -1 });

  var incomeAmount = 0;
  for (let i = 0; i < incomes.length; i++) {
    incomeAmount = incomeAmount + parseInt(incomes[i].amount);
  }

  const incomeCategories = await income.aggregate([
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
    incomes: incomes,
    incomeAmount: incomeAmount,
    incomeCategories: incomeCategories,
  });
});

const removeIncome = asyncHandler(async (req, res) => {
  await income.findOneAndDelete({ _id: req.body.incomeId });
  const userProgress = await progress.findOne({ user: req.userInfo._id });

  await progress.updateOne(
    { user: req.userInfo._id },
    {
      progress: userProgress.progress - 15,
      tmp: userProgress.tmp - 15,
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

  const totalIncomes = await income.count({
    user: req.userInfo._id,
    createdAt: { $gte: thisMonth },
  });

  const achievementIds = userProgress.newAchievement;

  if (
    totalIncomes <= 200 &&
    achievementIds.includes("62cc26c437473374a8eed577")
  ) {
    aId = achievementIds.indexOf("62cc26c437473374a8eed577");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62cc26c437473374a8eed577",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 15;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 15;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalIncomes <= 100 &&
    achievementIds.includes("62c0202d2744425ef8f43042")
  ) {
    aId = achievementIds.indexOf("62c0202d2744425ef8f43042");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62c0202d2744425ef8f43042",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 15;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 15;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  } else if (
    totalIncomes <= 30 &&
    achievementIds.includes("62cf736317d764d0c6ef52fc")
  ) {
    aId = achievementIds.indexOf("62cf736317d764d0c6ef52fc");
    achievementIds.splice(aId, 1);

    const pAchievement = await achievement.findOne({
      _id: "62cf736317d764d0c6ef52fc",
    });

    const totalProgress =
      userProgress.progress - pAchievement.progressPoint - 15;
    const totalProgressPoint =
      userProgress.tmp - pAchievement.progressPoint - 15;

    await progress.updateOne(
      { user: req.userInfo._id },
      {
        progress: totalProgress,
        tmp: totalProgressPoint,
        newAchievement: achievementIds,
      }
    );
  }

  res.send({ resM: "Income removed." });
});

const editIncome = (req, res) => {
  const { incomeId, name, amount, category } = req.body;

  const nameRegex = /^[a-zA-Z\s]*$/;
  const amountRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || amount.trim() === "" || category.trim() === "") {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!nameRegex.test(name)) {
    return res.status(400).send({ resM: "Invalid income name." });
  } else if (name.length <= 2 || name.length >= 16) {
    return res
      .status(400)
      .send({ resM: "Income name most contain 3 to 15 characters." });
  } else if (!amountRegex.test(amount)) {
    return res.status(400).send({ resM: "Invalid amount." });
  } else if (amount.length >= 8) {
    return res
      .status(400)
      .send({ resM: "Income amount most be less than one crore" });
  }

  income
    .updateOne(
      { _id: incomeId },
      {
        name: name,
        amount: amount,
        category: category,
      }
    )
    .then(() => {
      res.send({ resM: "Income edited." });
    });
};

const getCategorizedIncomes = asyncHandler(async (req, res) => {
  const category = req.body.category;

  if (category.trim() === "") {
    return res.send({ resM: "Provide income category." });
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

  const thisMonthIncomes = await income
    .find({
      user: req.userInfo._id,
      category: category,
      createdAt: { $gte: thisMonth },
    })
    .sort({ amount: -1 });

  res.send(thisMonthIncomes);
});

const getSpecificallyCategorizedIncomes = asyncHandler(async (req, res) => {
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

  const thisMonthIncomes = await income
    .find({
      user: req.userInfo._id,
      category: category,
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    })
    .sort({ amount: -1 });

  res.send(thisMonthIncomes);
});

const getCategorizedIncomeStartDate = asyncHandler(async (req, res) => {
  const category = req.body.category;

  if (category.trim() === "") {
    return res.send({ resM: "Provide income category." });
  }

  const firstIncomeCategory = await income
    .findOne({
      user: req.userInfo._id,
      category: category,
    })
    .sort({ createdAt: 1 });

  const currentDateTime = new Date();

  const startDate =
    firstIncomeCategory === null
      ? currentDateTime.toISOString().split("T")[0]
      : firstIncomeCategory.createdAt.toISOString().split("T")[0];

  res.send(startDate);
});

module.exports = {
  addIncome,
  getDWMIncomes,
  getSpecificIncomes,
  removeIncome,
  editIncome,
  getCategorizedIncomes,
  getSpecificallyCategorizedIncomes,
  getCategorizedIncomeStartDate,
};
